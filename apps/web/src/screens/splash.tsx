export function SplashScreen() {
  return (
    <div className="fixed inset-0 z-[100] flex flex-col items-center justify-center gap-4 bg-background">
      <img src="/icon.svg" alt="" className="size-16 rounded-lg" />
      <h1 className="font-display text-2xl font-semibold tracking-tight">Monthly Expense</h1>
      {/* Four dots that light up one after another, left to right. */}
      <div role="status" aria-label="Loading" className="mt-2 flex gap-2">
        {[0, 1, 2, 3].map((i) => (
          <span key={i} className="splash-dot size-2 rounded-full bg-primary" style={{ animationDelay: `${i * 0.15}s` }} />
        ))}
      </div>
    </div>
  )
}
