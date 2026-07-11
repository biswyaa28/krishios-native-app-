/**
 * App screen: step-by-step remedies & community tips (chat UI).
 */
export default function RemedyScreen() {
  return (
    <div className="absolute inset-0 bg-krish-cream text-krish-dark flex flex-col">
      {/* header */}
      <div className="px-4 pt-2 pb-3 flex items-center gap-2 border-b border-black/5">
        <span className="text-lg leading-none">‹</span>
        <div className="flex-1">
          <p className="text-[11px] font-semibold leading-tight">Treatment Plan</p>
          <p className="text-[9px] opacity-50">3 steps · 5–7 days</p>
        </div>
        <span className="w-7 h-7 rounded-full bg-krish-green/15 flex items-center justify-center text-[11px]">🌿</span>
      </div>

      {/* steps */}
      <div className="flex-1 overflow-hidden px-3 py-3 space-y-2.5">
        {[
          { n: 1, t: 'Remove infected leaves', d: 'Clip lower leaves with brown spots. Burn or bury them.', done: true },
          { n: 2, t: 'Apply neem oil spray', d: 'Mix 5ml neem oil per litre. Spray at dusk.', done: false, active: true },
          { n: 3, t: 'Reduce overhead watering', d: 'Water at the base to keep leaves dry.', done: false },
        ].map((s) => (
          <div
            key={s.n}
            className={`rounded-xl p-2.5 border ${
              s.active ? 'border-krish-green bg-white shadow-md' : 'border-black/5 bg-white/60'
            }`}
          >
            <div className="flex items-start gap-2">
              <span
                className={`mt-0.5 w-4 h-4 rounded-full flex items-center justify-center text-[8px] font-bold ${
                  s.done
                    ? 'bg-krish-green-lighter text-white'
                    : s.active
                    ? 'bg-krish-green text-white'
                    : 'bg-black/10 text-krish-dark'
                }`}
              >
                {s.done ? '✓' : s.n}
              </span>
              <div className="flex-1">
                <p className="text-[10px] font-semibold leading-tight">{s.t}</p>
                <p className="text-[9px] opacity-60 leading-snug mt-0.5">{s.d}</p>
              </div>
            </div>
          </div>
        ))}

        {/* community tip bubble */}
        <div className="rounded-xl bg-krish-green/10 p-2.5 ml-5">
          <div className="flex items-center gap-1.5 mb-1">
            <span className="w-4 h-4 rounded-full bg-krish-brown-light" />
            <span className="text-[9px] font-semibold">Rajesh · Nearby farmer</span>
          </div>
          <p className="text-[9px] opacity-70 leading-snug">
            "Neem oil worked for my tomatoes last season. Add a drop of dish soap 👍"
          </p>
        </div>
      </div>

      {/* input */}
      <div className="px-3 pb-4 pt-2">
        <div className="flex items-center gap-2 rounded-full bg-white border border-black/10 px-3 py-1.5">
          <span className="text-[10px] opacity-40 flex-1">Ask KrishiOS AI…</span>
          <span className="w-5 h-5 rounded-full bg-krish-green text-white flex items-center justify-center text-[9px]">↑</span>
        </div>
      </div>
    </div>
  );
}
