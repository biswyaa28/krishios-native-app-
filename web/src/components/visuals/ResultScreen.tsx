/**
 * App screen: AI diagnosis result / health report.
 */
export default function ResultScreen() {
  return (
    <div className="absolute inset-0 bg-krish-cream text-krish-dark">
      {/* header */}
      <div className="px-4 pt-2 pb-3 flex items-center gap-2">
        <span className="text-lg leading-none">‹</span>
        <span className="text-[11px] font-semibold flex-1">Health Report</span>
        <span className="text-[10px] opacity-50">Just now</span>
      </div>

      {/* hero leaf card */}
      <div className="mx-4 rounded-2xl overflow-hidden relative h-[110px] bg-gradient-to-br from-krish-green-light to-krish-green">
        <svg viewBox="0 0 200 110" className="absolute inset-0 w-full h-full opacity-80" preserveAspectRatio="xMidYMid slice">
          <path d="M100 95 C 100 70, 92 50, 100 30 C 120 50, 120 70, 100 95z" fill="#95d5b2" />
          <path d="M100 95 C 100 75, 108 60, 100 45 C 84 60, 84 75, 100 95z" fill="#74C69D" />
          <circle cx="92" cy="60" r="3.5" fill="#7F4F24" opacity="0.6" />
        </svg>
        <div className="absolute bottom-2 left-3 right-3 flex items-end justify-between">
          <div>
            <p className="text-[9px] uppercase tracking-wider text-white/70">Detected</p>
            <p className="text-sm font-bold text-white">Tomato Plant</p>
          </div>
          <span className="text-[10px] font-bold bg-krish-amber text-krish-dark px-2 py-0.5 rounded-full">
            82% Healthy
          </span>
        </div>
      </div>

      {/* diagnosis */}
      <div className="px-4 pt-3">
        <p className="text-[10px] uppercase tracking-wider opacity-50 mb-1">Finding</p>
        <div className="flex items-center gap-2 mb-2">
          <span className="w-2 h-2 rounded-full bg-krish-amber" />
          <span className="text-[11px] font-semibold">Early Blight — minor</span>
        </div>
        <p className="text-[10px] leading-relaxed opacity-70 mb-3">
          A fungal spot on lower leaves. Treatable in 5–7 days with the steps below.
        </p>

        {/* health bars */}
        <div className="space-y-2 mb-3">
          {[
            { label: 'Disease', val: 18, color: 'bg-krish-amber' },
            { label: 'Pests', val: 6, color: 'bg-krish-green-lighter' },
            { label: 'Nutrients', val: 28, color: 'bg-krish-brown-light' },
          ].map((m) => (
            <div key={m.label}>
              <div className="flex justify-between text-[9px] mb-0.5">
                <span className="opacity-60">{m.label}</span>
                <span className="font-semibold">{m.val}%</span>
              </div>
              <div className="h-1.5 rounded-full bg-black/10 overflow-hidden">
                <div className={`h-full ${m.color} rounded-full`} style={{ width: `${m.val}%` }} />
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* CTA */}
      <div className="absolute bottom-0 left-0 right-0 px-4 pb-4">
        <button className="w-full py-2.5 rounded-xl bg-krish-green text-white text-[11px] font-bold shadow-lg">
          View Remedies →
        </button>
      </div>
    </div>
  );
}
