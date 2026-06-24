self.addEventListener('notificationclick', e => {
  e.notification.close();
  const taskId = e.notification.data?.taskId;

  e.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(clientList => {
      // 이미 열린 탭이 있으면 포커스 후 메시지 전송
      for (const client of clientList) {
        if ('focus' in client) {
          client.focus();
          if (taskId) client.postMessage({ type: 'NAVIGATE_TASK', taskId });
          return;
        }
      }
      // 열린 탭이 없으면 새 탭으로 열기 (URL 파라미터로 taskId 전달)
      const url = taskId ? `/?task=${encodeURIComponent(taskId)}` : '/';
      return clients.openWindow(url);
    })
  );
});
