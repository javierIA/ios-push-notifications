async function run() {
  // A service worker must be registered in order to send notifications on iOS
  const registration = await navigator.serviceWorker.register(
    "serviceworker.js",
    {
      scope: "./",
    }
  );

  const button = document.getElementById("subscribe");
  button.addEventListener("click", async () => {
    // Triggers popup to request access to send notifications
    const result = await window.Notification.requestPermission();

    // If the user rejects the permission result will be "denied"
    if (result === "granted") {
      const subscription = await registration.pushManager.subscribe({
        applicationServerKey: "BAdl2bAWRk1KRQvez2rGL2WpvC6-1RRHAyYBq4ERtDeLFy4Rfu971-4VmdGAIYVPWVB3gC-y31g5l2BXDd7NUW0",
        userVisibleOnly: true,
      });

      await fetch("/save-subscription", {
        method: "post",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(subscription),
      });
    }
  });
}

run();
