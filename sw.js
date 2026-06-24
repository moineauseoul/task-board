self.addEventListener('notificationclick', e => {
  e.notification.close();
  const data = e.notification.data || {};
  const taskId = data.taskId;
  const openModal = data.openModal || false;

  e.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(clientList => {
      for (const client of clientList) {
        if ('focus' in client) {
          client.focus();
          if (taskId) client.postMessage({ type: 'NAVIGATE_TASK', taskId, openModal });
          return Promise.resolve();
        }
      }
      const url = taskId ? `/?task=${encodeURIComponent(taskId)}&openModal=${openModal}` : '/';
      return clients.openWindow(url);
    })
  );
});
