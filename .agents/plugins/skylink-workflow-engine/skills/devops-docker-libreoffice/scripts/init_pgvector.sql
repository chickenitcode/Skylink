-- ==============================================================================
-- SCRIPT KHỞI TẠO CƠ SỞ DỮ LIỆU POSTGRESQL 16 CHO GASCOLAE SKYLINK
-- Kích hoạt extension pgvector và cấu hình Full-Text Search tiếng Việt
-- ==============================================================================

-- 1. Kích hoạt extension pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Kiểm tra phiên bản extension đã cài đặt
SELECT extname, extversion FROM pg_extension WHERE extname = 'vector';

-- 3. Tạo bảng mẫu service_chunks để kiểm tra
CREATE TABLE IF NOT EXISTS service_chunks (
    id SERIAL PRIMARY KEY,
    chunk_id VARCHAR(64) UNIQUE NOT NULL,
    service_id VARCHAR(32) NOT NULL,
    record_type VARCHAR(32) NOT NULL,
    content TEXT NOT NULL,
    evidence_source_ids TEXT[] DEFAULT '{}',
    visibility VARCHAR(16) DEFAULT 'internal',
    status VARCHAR(16) DEFAULT 'verified',
    embedding vector(1536), -- Dimension khớp với OpenAI text-embedding-3-small (hoặc 768 với Google)
    fts_tokens tsvector,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Kích hoạt Trigger tự động cập nhật tsvector khi content thay đổi
CREATE OR REPLACE FUNCTION update_service_chunks_fts() RETURNS trigger AS $$
BEGIN
  new.fts_tokens := to_tsvector('simple', coalesce(new.content, ''));
  return new;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_service_chunks_fts ON service_chunks;
CREATE TRIGGER trg_service_chunks_fts
BEFORE INSERT OR UPDATE ON service_chunks
FOR EACH ROW EXECUTE FUNCTION update_service_chunks_fts();

-- 5. Tạo chỉ mục GIN cho FTS và HNSW cho Vector
CREATE INDEX IF NOT EXISTS idx_service_chunks_fts ON service_chunks USING GIN (fts_tokens);
CREATE INDEX IF NOT EXISTS idx_service_chunks_embedding ON service_chunks USING hnsw (embedding vector_cosine_ops) WITH (m = 16, ef_construction = 64);
