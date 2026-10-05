import { createHash } from 'crypto';

export interface ChunkIdOptions {
  prefix?: string;
  separator?: string;
  hashLength?: number;
  algorithm?: string;
}

export function generateDeterministicChunkId(
  serviceId: string,
  recordType: string,
  normalizedIndex: number,
  content: string,
  options: ChunkIdOptions = {}
): string {
  const prefix = options.prefix ?? (process.env.CHUNK_ID_PREFIX || 'CHK');
  const sep = options.separator ?? '-';
  const hashLength = options.hashLength ?? 16;
  const algo = options.algorithm ?? 'sha256';

  const cleanContent = content.trim().toLowerCase().replace(/\s+/g, ' ');
  const rawSeed = `${serviceId}:${recordType}:${normalizedIndex}:${cleanContent}`;
  const hash = createHash(algo).update(rawSeed, 'utf8').digest('hex').substring(0, hashLength);
  const typeAbbr = recordType.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().substring(0, 4);

  return `${prefix}${sep}${serviceId}${sep}${typeAbbr}${sep}${hash}`;
}

// Chạy thử nghiệm băm và kiểm tra tính bất biến (Idempotency)
function runTest() {
  console.log('=== TEST DETERMINISTIC CHUNK ID GENERATOR ===');
  const serviceId = 'S0112';
  const recordType = 'condition';
  const content = 'Khu vực quét đồi dốc tối đa 30 độ. Không bay khi gió > cấp 5.';

  const id1 = generateDeterministicChunkId(serviceId, recordType, 0, content);
  const id2 = generateDeterministicChunkId(serviceId, recordType, 0, content);

  console.log(`Lần 1: ${id1}`);
  console.log(`Lần 2: ${id2}`);

  if (id1 === id2) {
    console.log('[PASSED] Idempotent: 2 lần băm cùng nội dung cho ra cùng 1 chunk_id!');
  } else {
    console.error('[FAILED] Chunk ID không đồng nhất!');
    process.exit(1);
  }
}

runTest();
