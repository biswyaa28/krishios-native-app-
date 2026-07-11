import type { ReactNode } from 'react';

interface PhoneShellProps {
  children: ReactNode;
  /** Scale factor for the whole device. 1 = ~300px wide. */
  scale?: number;
  className?: string;
  /** Show floating reflection sheen */
  sheen?: boolean;
}

/**
 * A realistic phone device chrome rendered purely in CSS.
 * No external image assets required.
 */
export default function PhoneShell({
  children,
  scale = 1,
  className = '',
  sheen = true,
}: PhoneShellProps) {
  return (
    <div
      className={`phone-shell relative ${className}`}
      style={{
        width: `${300 * scale}px`,
        // height set by content; min tall aspect
      }}
    >
      {/* side buttons */}
      <div
        className="absolute left-[-3px] top-[88px] w-[3px] h-[44px] rounded-l bg-neutral-700"
        aria-hidden
      />
      <div
        className="absolute left-[-3px] top-[148px] w-[3px] h-[68px] rounded-l bg-neutral-700"
        aria-hidden
      />
      <div
        className="absolute right-[-3px] top-[120px] w-[3px] h-[84px] rounded-r bg-neutral-700"
        aria-hidden
      />

      <div
        className="phone-screen relative"
        style={{ aspectRatio: '9 / 19.5' }}
      >
        <div className="phone-notch" />
        {sheen && (
          <div
            className="pointer-events-none absolute inset-0 z-40"
            style={{
              background:
                'linear-gradient(125deg, rgba(255,255,255,0.18) 0%, rgba(255,255,255,0) 22%, rgba(255,255,255,0) 78%, rgba(255,255,255,0.08) 100%)',
            }}
            aria-hidden
          />
        )}
        {/* status bar */}
        <div className="absolute top-0 left-0 right-0 z-20 flex items-center justify-between px-5 pt-[10px] text-[10px] font-semibold text-current">
          <span className="tracking-tight">9:41</span>
          <div className="flex items-center gap-1 opacity-80">
            {/* signal */}
            <svg width="14" height="9" viewBox="0 0 14 9" fill="none">
              <rect x="0" y="6" width="2" height="3" rx="0.5" fill="currentColor" />
              <rect x="3.5" y="4" width="2" height="5" rx="0.5" fill="currentColor" />
              <rect x="7" y="2" width="2" height="7" rx="0.5" fill="currentColor" />
              <rect x="10.5" y="0" width="2" height="9" rx="0.5" fill="currentColor" />
            </svg>
            {/* wifi */}
            <svg width="13" height="9" viewBox="0 0 13 9" fill="none">
              <path d="M6.5 8.5l1.6-1.9a2.1 2.1 0 0 0-3.2 0L6.5 8.5z" fill="currentColor" />
              <path d="M2.5 4.4a6 6 0 0 1 8 0" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round" fill="none" />
              <path d="M.6 2.3a9 9 0 0 1 11.8 0" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round" fill="none" />
            </svg>
            {/* battery */}
            <svg width="22" height="10" viewBox="0 0 22 10" fill="none">
              <rect x="0.5" y="0.5" width="18" height="9" rx="2" stroke="currentColor" opacity="0.5" fill="none" />
              <rect x="2" y="2" width="13" height="6" rx="1" fill="currentColor" />
              <rect x="19.5" y="3.2" width="1.6" height="3.6" rx="0.8" fill="currentColor" opacity="0.6" />
            </svg>
          </div>
        </div>

        {/* screen content */}
        <div className="absolute inset-0 pt-[34px]">{children}</div>
      </div>
    </div>
  );
}
