export interface ProposalSummary {
  proposalCode: string;
  clientName: string;
  totalEstimatedItems: number;
  hasDisclaimer: boolean;
  watermark: string;
}

export function validateProposalForRendering(payload: Record<string, any>): { valid: boolean; summary: ProposalSummary; errors: string[] } {
  const errors: string[] = [];

  if (!payload.proposal_code) errors.push('Thiếu proposal_code');
  if (!payload.client_name) errors.push('Thiếu client_name');
  if (!payload.legal_disclaimer) errors.push('Thiếu tuyên bố miễn trừ pháp lý sơ bộ');

  const summary: ProposalSummary = {
    proposalCode: payload.proposal_code || 'N/A',
    clientName: payload.client_name || 'N/A',
    totalEstimatedItems: (payload.scope_of_work?.deliverables || []).length,
    hasDisclaimer: Boolean(payload.legal_disclaimer),
    watermark: payload.status === 'APPROVED' ? 'OFFICIAL' : 'BẢN THẢO SƠ BỘ',
  };

  return {
    valid: errors.length === 0,
    summary,
    errors,
  };
}

function runRenderTest() {
  console.log('=== TEST PROPOSAL RENDER VALIDATOR ===');
  const samplePayload = {
    proposal_code: 'PROP-S0112-2026-001',
    client_name: 'Hợp Tác Xã Nông Nghiệp Di Linh',
    status: 'REVIEW_REQUIRED',
    legal_disclaimer: 'Tài liệu này là bản thảo kỹ thuật sơ bộ...',
    scope_of_work: {
      deliverables: ['Bản đồ trực giao Orthomosaic', 'Báo cáo chỉ số thực vật NDVI']
    }
  };

  const result = validateProposalForRendering(samplePayload);
  console.log('Kết quả kiểm tra trước khi render DOCX:');
  console.table(result.summary);

  if (result.valid) {
    console.log('[PASSED] Dữ liệu đủ điều kiện để nạp vào docxtemplater & LibreOffice!');
  } else {
    console.error('[FAILED] Dữ liệu không hợp lệ:', result.errors);
    process.exit(1);
  }
}

runRenderTest();
