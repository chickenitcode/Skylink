---
name: devops-docker-libreoffice
description: Hướng dẫn cấu hình hạ tầng Docker Compose cho PostgreSQL 16 kết hợp pgvector, Prisma raw migration và thiết lập worker headless LibreOffice chuyển đổi tài liệu DOCX sang PDF ổn định, chống lỗi font và zombie process.
---

# KỸ NĂNG DEVOPS DOCKER & WORKER LIBREOFFICE (devops-docker-libreoffice)

## 1. MỤC TIÊU HẠ TẦNG & THIẾT KẾ CẤU HÌNH ĐỘNG
Kỹ năng này hướng dẫn Thành viên B (Backend/DevOps) triển khai hạ tầng có thể cấu hình linh hoạt qua biến môi trường:
- **Database Container**: PostgreSQL 16 + `pgvector` với thông số user, password, port lấy động từ `.env`.
- **Vector Dimension linh hoạt**: Chỉ mục vector điều chỉnh linh hoạt theo mô hình embedding thực tế.
- **Worker PDF an toàn**: Headless LibreOffice với tham số timeout, buffer và dọn tệp tạm có thể tùy biến.

---

## 2. CẤU HÌNH DOCKER COMPOSE THAM SỐ HÓA (`docker-compose.yml`)

```yaml
version: '3.8'

services:
  postgres:
    image: pgvector/pgvector:pg16
    container_name: ${CONTAINER_NAME_POSTGRES:-skylink-postgres}
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-skylink_admin}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:?Vui long khai bao POSTGRES_PASSWORD trong tep .env}
      POSTGRES_DB: ${POSTGRES_DB:-skylink_db}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-skylink_admin} -d ${POSTGRES_DB:-skylink_db}"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - skylink-network

networks:
  skylink-network:
    driver: bridge

volumes:
  postgres_data:
```

---

## 3. PRISMA MIGRATION THAM SỐ HÓA CHỈ MỤC VECTOR & FTS

Khi tạo tệp migration raw SQL tại `prisma/migrations/0_init_vector/migration.sql`, cần chú ý kích thước chiều vector (`dimension`) phải khớp với mô hình embedding lựa chọn:

> [!NOTE]
> - `vector(1536)`: Sử dụng cho OpenAI `text-embedding-3-small` hoặc `text-embedding-ada-002`.
> - `vector(768)`: Sử dụng cho Google `text-embedding-004`, `bge-base-en-v1.5`, hoặc `nomic-embed-text`.
> - `vector(3072)`: Sử dụng cho OpenAI `text-embedding-3-large`.

```sql
-- 1. Kích hoạt extension pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Thêm cột tsvector phục vụ Full-Text Search
ALTER TABLE "service_chunks" ADD COLUMN IF NOT EXISTS "fts_tokens" tsvector;

-- 3. Tạo chỉ mục GIN cho FTS
CREATE INDEX IF NOT EXISTS "idx_service_chunks_fts" ON "service_chunks" USING GIN ("fts_tokens");

-- 4. Tạo chỉ mục HNSW cho vector similarity search
-- Lưu ý: Thay đổi dimension theo model cấu hình trong .env (mặc định ví dụ 1536)
CREATE INDEX IF NOT EXISTS "idx_service_chunks_embedding" ON "service_chunks" 
USING hnsw ("embedding" vector_cosine_ops) WITH (m = 16, ef_construction = 64);
```

---

## 4. WORKER LIBREOFFICE THAM SỐ HÓA VÀ AN TOÀN TIẾN TRÌNH

### 4.1. Cài đặt font tiếng Việt trong Dockerfile:
```dockerfile
FROM node:20-alpine

# Cài đặt LibreOffice và bộ font tiếng Việt Unicode
RUN apk add --no-cache \
    libreoffice \
    font-noto \
    font-noto-cjk \
    msttcorefonts-installer && \
    update-ms-fonts && \
    fc-cache -f
```

### 4.2. Hàm chuyển đổi PDF có cấu hình Timeout và Dọn Dẹp (`services/pdfConverter.ts`):
```typescript
import { exec } from 'child_process';
import { promisify } from 'util';
import * as path from 'path';
import * as fs from 'fs';

const execAsync = promisify(exec);

export interface PdfConversionOptions {
  timeoutMs?: number;
  maxBufferBytes?: number;
  autoCleanInput?: boolean;
}

export async function convertDocxToPdf(
  inputDocxPath: string,
  outputDir: string,
  options: PdfConversionOptions = {}
): Promise<string> {
  const timeoutMs = options.timeoutMs || Number(process.env.LIBREOFFICE_TIMEOUT_MS) || 30000;
  const maxBuffer = options.maxBufferBytes || 10 * 1024 * 1024; // 10MB buffer

  // Chạy lệnh chuyển đổi với timeout chống zombie process
  const cmd = `soffice --headless --convert-to pdf "${inputDocxPath}" --outdir "${outputDir}"`;
  
  await execAsync(cmd, { timeout: timeoutMs, maxBuffer });

  const baseName = path.basename(inputDocxPath, path.extname(inputDocxPath));
  const outputPdfPath = path.join(outputDir, `${baseName}.pdf`);

  if (!fs.existsSync(outputPdfPath)) {
    throw new Error(`LibreOffice không thể tạo tệp PDF tại: ${outputPdfPath}`);
  }

  // Tùy chọn tự động dọn dẹp file DOCX tạm nếu được yêu cầu
  if (options.autoCleanInput && fs.existsSync(inputDocxPath)) {
    try {
      fs.unlinkSync(inputDocxPath);
    } catch (err) {
      console.warn(`Không thể xóa tệp tạm ${inputDocxPath}:`, err);
    }
  }

  return outputPdfPath;
}
```
