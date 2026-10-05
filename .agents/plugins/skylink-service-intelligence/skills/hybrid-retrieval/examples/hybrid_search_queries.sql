-- ==============================================================================
-- CÁC MẪU CÂU LỆNH TRUY VẤN LAI HYBRID RETRIEVAL THỰC CHIẾN (POSTGRESQL + PGVECTOR)
-- ==============================================================================

-- 1. Truy vấn kết hợp cân bằng (Balanced Profile: fts_weight = 1.0, vec_weight = 1.0, k = 60)
WITH fts_candidates AS (
  SELECT 
    id, chunk_id, service_id, content, evidence_source_ids, visibility, status,
    ROW_NUMBER() OVER (
      ORDER BY ts_rank_cd(fts_tokens, websearch_to_tsquery('simple', 'máy bay viễn thám nấm bệnh 500ha đồi dốc')) DESC
    ) AS fts_rank
  FROM service_chunks
  WHERE 
    status = 'verified'
    AND visibility = ANY(ARRAY['public', 'internal'])
    AND fts_tokens @@ websearch_to_tsquery('simple', 'máy bay viễn thám nấm bệnh 500ha đồi dốc')
  LIMIT 25
),
vector_candidates AS (
  SELECT 
    id, chunk_id, service_id, content, evidence_source_ids, visibility, status,
    ROW_NUMBER() OVER (
      ORDER BY embedding <=> '[0.012,-0.045,0.038,...]'::vector(1536)
    ) AS vec_rank
  FROM service_chunks
  WHERE 
    status = 'verified'
    AND visibility = ANY(ARRAY['public', 'internal'])
  LIMIT 25
)
SELECT 
  COALESCE(f.chunk_id, v.chunk_id) AS chunk_id,
  COALESCE(f.service_id, v.service_id) AS service_id,
  COALESCE(f.content, v.content) AS content,
  COALESCE(f.evidence_source_ids, v.evidence_source_ids) AS evidence_source_ids,
  COALESCE(f.visibility, v.visibility) AS visibility,
  (
    COALESCE(1.0 / (60 + f.fts_rank), 0.0) +
    COALESCE(1.0 / (60 + v.vec_rank), 0.0)
  ) AS rrf_score
FROM fts_candidates f
FULL OUTER JOIN vector_candidates v ON f.id = v.id
ORDER BY rrf_score DESC
LIMIT 5;

-- 2. Truy vấn chỉ tìm kiếm theo Mã dịch vụ hoặc Mã cảm biến chính xác (Keyword Heavy)
SELECT chunk_id, service_id, content, evidence_source_ids
FROM service_chunks
WHERE 
  status = 'verified'
  AND (content ILIKE '%S0112%' OR content ILIKE '%RedEdge-P%')
LIMIT 5;
