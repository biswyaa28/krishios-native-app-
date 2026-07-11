/**
 * An emotive SVG scene of a farmer figure looking over a wilting field
 * under a worried, overcast sky. Used in the Problem side of the page.
 */
export default function FarmerField({ className = '' }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 400 520"
      className={className}
      preserveAspectRatio="xMidYMid slice"
      aria-label="A farmer looking at a wilting crop"
    >
      <defs>
        <linearGradient id="sky-w" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#d8d3c4" />
          <stop offset="100%" stopColor="#b8b3a3" />
        </linearGradient>
        <linearGradient id="soil-w" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#7F4F24" />
          <stop offset="100%" stopColor="#5B3A1A" />
        </linearGradient>
        <radialGradient id="sun-w" cx="78%" cy="20%" r="22%">
          <stop offset="0%" stopColor="#E9A23B" stopOpacity="0.5" />
          <stop offset="100%" stopColor="#E9A23B" stopOpacity="0" />
        </radialGradient>
      </defs>

      {/* sky */}
      <rect width="400" height="360" fill="url(#sky-w)" />
      <rect width="400" height="360" fill="url(#sun-w)" />

      {/* distant wilted rows */}
      {Array.from({ length: 9 }).map((_, i) => (
        <ellipse
          key={i}
          cx={20 + i * 45}
          cy={340 - (i % 2) * 8}
          rx="34"
          ry="9"
          fill="#5a6b3a"
          opacity="0.4"
        />
      ))}

      {/* soil */}
      <path d="M0,330 Q200,300 400,335 L400,520 L0,520 Z" fill="url(#soil-w)" />

      {/* foreground wilted plant — drooping */}
      <g transform="translate(150,300)">
        <path d="M0,200 C -2,140 4,90 0,40" stroke="#3a5a40" strokeWidth="4" fill="none" strokeLinecap="round" />
        {/* drooping leaves */}
        <path d="M0,70 C -28,80 -40,60 -46,30 C -20,28 -4,40 0,70z" fill="#6b7a44" opacity="0.85" />
        <path d="M0,55 C 26,68 42,50 48,18 C 20,18 4,30 0,55z" fill="#7a8a52" opacity="0.85" />
        {/* a dead tip */}
        <path d="M0,40 L -4,18 L 6,22 Z" fill="#9b6b3a" opacity="0.8" />
        {/* brown spot */}
        <circle cx="-22" cy="44" r="6" fill="#5B3A1A" opacity="0.7" />
        <circle cx="30" cy="40" r="5" fill="#5B3A1A" opacity="0.6" />
      </g>

      {/* farmer silhouette — back view, looking out */}
      <g transform="translate(280,210)">
        {/* body */}
        <path d="M0,0 C -22,2 -30,20 -30,48 C -30,80 -16,120 -8,150 L 24,150 C 30,120 40,80 40,48 C 40,20 24,0 8,0 Z" fill="#3a2a1a" />
        {/* head with turban-ish wrap */}
        <ellipse cx="6" cy="-16" rx="18" ry="20" fill="#4a3525" />
        <path d="M-12,-22 C -8,-34 20,-34 24,-22 C 20,-16 -8,-16 -12,-22z" fill="#7F4F24" />
        {/* dhoti lower */}
        <path d="M-8,150 L 24,150 L 30,210 L -14,210 Z" fill="#c9b89a" />
        {/* arm holding cap brim */}
        <path d="M-22,40 C -38,30 -44,10 -40,-2 C -34,8 -28,28 -16,40z" fill="#4a3525" />
      </g>

      {/* a single worried thought */}
      <g transform="translate(250,150)" opacity="0.7">
        <circle cx="0" cy="0" r="3" fill="#fff" />
        <circle cx="10" cy="-8" r="5" fill="#fff" />
        <ellipse cx="26" cy="-22" rx="22" ry="14" fill="#fff" />
        <text x="26" y="-18" textAnchor="middle" fontSize="13" fontWeight="700" fill="#5B3A1A">?</text>
      </g>
    </svg>
  );
}
