export type ConsultationState = 
  | 'DISCOVERY'
  | 'COLLECTING_REQUIREMENTS'
  | 'SERVICE_MATCHING'
  | 'SERVICE_RECOMMENDED'
  | 'PROPOSAL_READY'
  | 'PROPOSAL_GENERATED'
  | 'REVIEW_REQUIRED'
  | 'APPROVED';

export interface ConsultationSession {
  sessionId: string;
  state: ConsultationState;
  collectedRequirements: Record<string, any>;
  missingFields: string[];
}

export function advanceConsultationState(
  session: ConsultationSession,
  requiredFieldList: string[]
): ConsultationSession {
  const currentCollected = Object.keys(session.collectedRequirements);
  const stillMissing = requiredFieldList.filter(f => !currentCollected.includes(f));

  if (stillMissing.length > 0) {
    return {
      ...session,
      state: 'COLLECTING_REQUIREMENTS',
      missingFields: stillMissing,
    };
  }

  return {
    ...session,
    state: 'SERVICE_MATCHING',
    missingFields: [],
  };
}

function runSimulation() {
  console.log('=== MÔ PHỎNG MÁY TRẠNG THÁI TƯ VẤN (STATE MACHINE) ===');
  const requiredFields = ['problem', 'objective', 'deployment_context', 'timeline_expectation'];

  let session: ConsultationSession = {
    sessionId: 'SESS-2026-001',
    state: 'DISCOVERY',
    collectedRequirements: { problem: 'Cây cà phê bị đốm lá nấm bệnh', objective: 'Khảo sát khoanh vùng' },
    missingFields: ['deployment_context', 'timeline_expectation'],
  };

  console.log(`Ban đầu: Trạng thái = ${session.state}, Thiếu = [${session.missingFields.join(', ')}]`);

  // Bước 1: Khách bổ sung 1 trường
  session.collectedRequirements.deployment_context = 'Đồi dốc 500ha tại Lâm Đồng';
  session = advanceConsultationState(session, requiredFields);
  console.log(`Sau lượt 1: Trạng thái = ${session.state}, Còn thiếu = [${session.missingFields.join(', ')}]`);

  // Bước 2: Khách bổ sung nốt trường cuối
  session.collectedRequirements.timeline_expectation = 'Tháng 11/2026';
  session = advanceConsultationState(session, requiredFields);
  console.log(`Sau lượt 2: Trạng thái = ${session.state}, Còn thiếu = [${session.missingFields.join(', ')}]`);

  if (session.state === 'SERVICE_MATCHING' && session.missingFields.length === 0) {
    console.log('[PASSED] Máy trạng thái chuyển bước chính xác khi đủ 100% trường bắt buộc!');
  } else {
    console.error('[FAILED] Chuyển trạng thái sai!');
    process.exit(1);
  }
}

runSimulation();
