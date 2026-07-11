/**
 * App screen: live camera viewfinder scanning a leaf.
 * Pure CSS/SVG. The "photo" is an SVG plant illustration.
 */
export default function ScanScreen() {
  return (
    <div className="absolute inset-0 bg-gradient-to-b from-neutral-900 to-neutral-800 text-white">
      {/* Top bar */}
      <div className="flex items-center justify-between px-4 pt-2 pb-3">
        <span className="text-[11px] font-semibold opacity-80">Crop Scan</span>
        <span className="text-[10px] px-2 py-0.5 rounded-full bg-krish-green/30 text-krish-green-glow border border-krish-green-glow/30">
          ● Offline AI
        </span>
      </div>

      {/* Viewfinder */}
      <div className="relative mx-4 rounded-2xl overflow-hidden h-[260px] bg-gradient-to-b from-krish-green-glow/20 to-krish-green/30">
        {/* the "plant" */}
        <svg viewBox="0 0 200 260" className="absolute inset-0 w-full h-full" preserveAspectRatio="xMidYMid slice">
          <defs>
            <radialGradient id="soil" cx="50%" cy="100%" r="80%">
              <stop offset="0%" stopColor="#5B3A1A" />
              <stop offset="100%" stopColor="#2a1a08" />
            </radialGradient>
            <linearGradient id="leafg" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="#74C69D" />
              <stop offset="100%" stopColor="#2D6A4F" />
            </linearGradient>
          </defs>
          <rect width="200" height="260" fill="url(#soil)" opacity="0.35" />
          {/* stem */}
          <path d="M100 250 C 100 200, 96 160, 100 120" stroke="#3a5a40" strokeWidth="5" fill="none" strokeLinecap="round" />
          {/* leaves */}
          <path d="M100 170 C 70 160, 50 175, 44 205 C 80 205, 96 195, 100 170z" fill="url(#leafg)" />
          <path d="M100 150 C 130 138, 152 152, 158 182 C 122 182, 104 175, 100 150z" fill="url(#leafg)" />
          <path d="M100 120 C 76 112, 60 124, 56 150 C 88 150, 96 142, 100 120z" fill="#95d5b2" />
          {/* a concerning spot */}
          <circle cx="78" cy="188" r="6" fill="#7F4F24" opacity="0.7" />
          <circle cx="84" cy="195" r="4" fill="#7F4F24" opacity="0.6" />
        </svg>

        {/* corner brackets */}
        <div className="absolute inset-6">
          {['top-0 left-0 border-t-2 border-l-2', 'top-0 right-0 border-t-2 border-r-2', 'bottom-0 left-0 border-b-2 border-l-2', 'bottom-0 right-0 border-b-2 border-r-2'].map(
            (c) => (
              <div key={c} className={`absolute w-5 h-5 border-krish-green-glow rounded ${c}`} />
            )
          )}
        </div>

        {/* scan beam */}
        <div className="absolute left-0 right-0 h-[3px] bg-krish-green-glow shadow-[0_0_14px_4px_rgba(116,198,157,0.7)] animate-scanbeam" />

        {/* detected tag */}
        <div className="absolute bottom-3 left-3 flex items-center gap-1.5 bg-black/40 backdrop-blur-sm rounded-lg px-2 py-1">
          <span className="w-1.5 h-1.5 rounded-full bg-krish-amber animate-pulse" />
          <span className="text-[9px] font-medium">Analyzing leaf…</span>
        </div>
      </div>

      {/* shutter + modes */}
      <div className="flex items-center justify-around px-6 pt-4">
        <div className="flex flex-col items-center gap-1 opacity-70">
          <div className="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center">
            <span className="text-xs">⊞</span>
          </div>
          <span className="text-[8px]">Gallery</span>
        </div>
        <button className="w-14 h-14 rounded-full bg-white flex items-center justify-center ring-4 ring-white/30">
          <span className="w-11 h-11 rounded-full bg-krish-green-lighter" />
        </button>
        <div className="flex flex-col items-center gap-1 opacity-70">
          <div className="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center">
            <span className="text-xs">↻</span>
          </div>
          <span className="text-[8px]">Flip</span>
        </div>
      </div>
    </div>
  );
}
