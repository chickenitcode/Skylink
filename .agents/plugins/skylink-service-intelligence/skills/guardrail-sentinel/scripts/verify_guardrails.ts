export interface AuditResult {
  passed: boolean;
  violations: string[];
}

export function testGuardrailEngine(
  rationale: string,
  citations: string[],
  validDatabaseChunkIds: Set<string>,
  prohibitedRegexList: RegExp[]
): AuditResult {
  const violations: string[] = [];

  // 1. Kiểm tra Citation
  for (const cid of citations) {
    if (!validDatabaseChunkIds.has(cid)) {
      violations.push(`ẢO GIÁC CITATION: Chunk '${cid}' không tồn tại trong DB!`);
    }
  }

  // 2. Kiểm tra Regex Giá & Cam kết cấm
  for (const reg of prohibitedRegexList) {
    if (reg.test(rationale)) {
      violations.push(`VI PHẠM QUY TẮC: Phát hiện từ khóa nhạy cảm khớp với mẫu ${reg.source}`);
    }
  }

  return {
    passed: violations.length === 0,
    violations,
  };
}

function runAuditTest() {
  console.log('=== TEST GUARDRAIL SENTINEL VERIFIER ===');
  const validDbChunks = new Set(['CHK-S0112-COND-01', 'CHK-S0112-CAPA-02']);
  const prohibitedPatterns = [
    /(\b\d+[\.,]?\d*\s*(vnđ|vnd|triệu|usd|\$)\b)/i,
    /(cam kết 100%|chính xác tuyệt đối)/i,
  ];

  // Case 1: Lỗi ảo giác giá và fake citation
  const badCase = testGuardrailEngine(
    'Dịch vụ có giá chỉ 25 triệu VNĐ và cam kết 100% không sót nấm bệnh.',
    ['CHK-S0112-COND-01', 'CHK-FAKE-999'],
    validDbChunks,
    prohibitedPatterns
  );

  console.log('Kết quả kiểm tra câu trả lời vi phạm:');
  console.log(`- Trạng thái: ${badCase.passed ? 'PASSED' : 'BLOCKED (Đúng kỳ vọng)'}`);
  console.log('- Các vi phạm bắt được:', badCase.violations);

  if (!badCase.passed && badCase.violations.length === 3) {
    console.log('[PASSED] Guardrail bắt trúng 100% các vi phạm ảo giác giá, cam kết tuyệt đối và fake citation!');
  } else {
    console.error('[FAILED] Guardrail không bắt đủ vi phạm!');
    process.exit(1);
  }
}

runAuditTest();
