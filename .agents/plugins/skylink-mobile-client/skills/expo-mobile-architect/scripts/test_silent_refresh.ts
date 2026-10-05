export class MockRefreshQueue {
  private isRefreshing = false;
  private queue: Array<(token: string) => void> = [];

  async request(requestId: string, isExpiredToken: boolean): Promise<string> {
    if (isExpiredToken) {
      if (this.isRefreshing) {
        console.log(`[Queue] Request ${requestId} xếp hàng chờ token mới...`);
        return new Promise(resolve => {
          this.queue.push(resolve);
        });
      }

      this.isRefreshing = true;
      console.log(`[Refresh] Request ${requestId} phát hiện 401 -> Đang gọi refresh token...`);
      
      // Giả lập độ trễ mạng làm mới token 200ms
      await new Promise(r => setTimeout(r, 200));
      const newToken = `NEW_JWT_${Date.now()}`;
      console.log(`[Success] Đã nhận token mới: ${newToken}`);

      // Giải phóng hàng đợi
      this.queue.forEach(resolve => resolve(newToken));
      this.queue = [];
      this.isRefreshing = false;

      return newToken;
    }

    return 'CURRENT_VALID_TOKEN';
  }
}

async function runSilentRefreshTest() {
  console.log('=== TEST AXIOS SILENT REFRESH QUEUE (CHỐNG RACE CONDITION) ===');
  const client = new MockRefreshQueue();

  // Bắn 3 request đồng thời khi token hết hạn
  const results = await Promise.all([
    client.request('REQ_01', true),
    client.request('REQ_02', true),
    client.request('REQ_03', true),
  ]);

  console.log('Kết quả 3 request:');
  console.table(results);

  const allEqual = results[0] === results[1] && results[1] === results[2];
  if (allEqual && results[0].startsWith('NEW_JWT_')) {
    console.log('[PASSED] Cả 3 request đồng thời đều nhận chung 1 token mới mà không gọi refresh lặp lại!');
  } else {
    console.error('[FAILED] Race condition xảy ra!');
    process.exit(1);
  }
}

runSilentRefreshTest();
