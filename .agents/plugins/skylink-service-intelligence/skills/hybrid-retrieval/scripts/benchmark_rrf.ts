export interface RankedItem {
  id: string;
  rank: number;
}

export function calculateRRFScore(
  ftsRank: number | null,
  vecRank: number | null,
  k: number = 60,
  ftsWeight: number = 1.0,
  vecWeight: number = 1.0
): number {
  let score = 0;
  if (ftsRank !== null && ftsRank > 0) {
    score += ftsWeight / (k + ftsRank);
  }
  if (vecRank !== null && vecRank > 0) {
    score += vecWeight / (k + vecRank);
  }
  return score;
}

function runBenchmark() {
  console.log('=== BENCHMARK RECIPROCAL RANK FUSION (RRF) ===');
  const k = 60;

  // Giả lập 3 chunk ứng viên
  const chunks = [
    { id: 'CHUNK_A', ftsRank: 1, vecRank: 10, note: 'Khớp từ khóa chính xác nhưng ngữ nghĩa trung bình' },
    { id: 'CHUNK_B', ftsRank: 5, vecRank: 2, note: 'Ngữ nghĩa rất cao, từ khóa tương đối' },
    { id: 'CHUNK_C', ftsRank: null, vecRank: 1, note: 'Ngữ nghĩa cao nhất nhưng không có từ khóa chính xác' },
  ];

  const results = chunks.map(c => ({
    id: c.id,
    note: c.note,
    balancedScore: calculateRRFScore(c.ftsRank, c.vecRank, k, 1.0, 1.0),
    keywordBiasedScore: calculateRRFScore(c.ftsRank, c.vecRank, k, 1.5, 0.8),
  })).sort((a, b) => b.balancedScore - a.balancedScore);

  console.table(results);
  console.log('[PASSED] RRF Benchmark hoàn thành mô phỏng thành công!');
}

runBenchmark();
