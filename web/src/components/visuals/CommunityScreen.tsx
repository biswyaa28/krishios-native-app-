/**
 * App screen: community feed of farmers sharing crops & tips.
 */
export default function CommunityScreen() {
  const posts = [
    {
      name: 'Lakshmi',
      place: 'Tamil Nadu',
      initials: 'L',
      color: 'bg-krish-amber',
      text: 'Saved my paddy from blast disease 🌾 thanks to the offline report!',
      likes: 124,
    },
    {
      name: 'Arjun',
      place: 'Punjab',
      initials: 'A',
      color: 'bg-krish-brown-light',
      text: 'Anyone growing tomatoes organically? Sharing my neem spray mix below.',
      likes: 88,
    },
    {
      name: 'Fatima',
      place: 'Karnataka',
      initials: 'F',
      color: 'bg-krish-green-light',
      text: 'Mango trees looking healthy this season 🥭☀️',
      likes: 56,
    },
  ];
  return (
    <div className="absolute inset-0 bg-krish-cream text-krish-dark flex flex-col">
      {/* header */}
      <div className="px-4 pt-2 pb-2 flex items-center justify-between">
        <span className="text-[11px] font-bold">Community</span>
        <span className="text-[9px] px-2 py-0.5 rounded-full bg-krish-green/15 text-krish-green font-semibold">
          1,000+ farmers
        </span>
      </div>

      {/* stories row */}
      <div className="flex gap-2 px-4 pb-2 overflow-hidden">
        {['+', 'L', 'A', 'F', 'R'].map((s, i) => (
          <div
            key={i}
            className={`w-8 h-8 rounded-full flex-shrink-0 flex items-center justify-center text-[10px] font-bold ${
              s === '+' ? 'border-2 border-dashed border-krish-green/40 text-krish-green' : 'ring-2 ring-krish-green-lighter ' + ['bg-krish-amber', 'bg-krish-brown-light', 'bg-krish-green-light', 'bg-krish-green'][i % 4]
            } text-white`}
          >
            {s}
          </div>
        ))}
      </div>

      {/* feed */}
      <div className="flex-1 overflow-hidden px-3 space-y-2">
        {posts.map((p, i) => (
          <div key={i} className="rounded-xl bg-white border border-black/5 p-2.5 shadow-sm">
            <div className="flex items-center gap-1.5 mb-1.5">
              <span className={`w-5 h-5 rounded-full ${p.color} text-white text-[8px] font-bold flex items-center justify-center`}>
                {p.initials}
              </span>
              <div className="leading-tight">
                <p className="text-[9px] font-semibold">{p.name}</p>
                <p className="text-[8px] opacity-50">{p.place}</p>
              </div>
            </div>
            {/* a tiny crop swatch */}
            <div className={`h-8 rounded-md mb-1.5 bg-gradient-to-br ${i === 0 ? 'from-krish-green-glow to-krish-green' : i === 1 ? 'from-krish-amber to-krish-brown' : 'from-krish-green-lighter to-krish-green-light'}`} />
            <p className="text-[9px] leading-snug opacity-80">{p.text}</p>
            <div className="flex items-center gap-3 mt-1.5 text-[8px] opacity-60">
              <span>♥ {p.likes}</span>
              <span>💬 12</span>
              <span>↗ share</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
