export interface AuditLogEntry {
  id: string;
  eventType: 'STATE_TRANSITION' | 'RETRIEVAL_TRACE' | 'GUARDRAIL_VIOLATION' | 'PROPOSAL_EVENT';
  actorId: string;
  actorRole: string;
  sessionId?: string;
  proposalId?: string;
  details: Record<string, any>;
  timestamp: string;
}

export class AuditLogSimulator {
  private logs: AuditLogEntry[] = [];

  record(event: Omit<AuditLogEntry, 'id' | 'timestamp'>): AuditLogEntry {
    const entry: AuditLogEntry = {
      ...event,
      id: `AUDIT-${Date.now()}-${Math.floor(Math.random() * 1000)}`,
      timestamp: new Date().toISOString(),
    };
    this.logs.push(entry);
    return entry;
  }

  queryByActor(actorId: string): AuditLogEntry[] {
    return this.logs.filter(l => l.actorId === actorId);
  }

  queryViolations(): AuditLogEntry[] {
    return this.logs.filter(l => l.eventType === 'GUARDRAIL_VIOLATION');
  }
}

function runAuditSimulatorTest() {
  console.log('=== TEST AUDIT LOG SIMULATOR ===');
  const sim = new AuditLogSimulator();

  sim.record({
    eventType: 'STATE_TRANSITION',
    actorId: 'USR-SALES-01',
    actorRole: 'SALES',
    sessionId: 'SESS-2026-001',
    details: { from: 'COLLECTING_REQUIREMENTS', to: 'SERVICE_MATCHING' },
  });

  sim.record({
    eventType: 'GUARDRAIL_VIOLATION',
    actorId: 'SYSTEM_SENTINEL',
    actorRole: 'SYSTEM',
    sessionId: 'SESS-2026-001',
    details: { reason: 'Phát hiện con số giá 20 triệu không căn cứ' },
  });

  const violations = sim.queryViolations();
  console.log(`Đã ghi nhận ${sim['logs'].length} sự kiện audit. Số vi phạm = ${violations.length}`);

  if (violations.length === 1 && violations[0].actorId === 'SYSTEM_SENTINEL') {
    console.log('[PASSED] Hệ thống ghi nhận và truy vấn Audit Log thành công!');
  } else {
    console.error('[FAILED] Ghi nhận Audit Log thất bại!');
    process.exit(1);
  }
}

runAuditSimulatorTest();
