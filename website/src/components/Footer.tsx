"use client";

import Link from "next/link";
import Image from "next/image";
import { ShieldCheck } from "lucide-react";
import { GithubIcon } from "./Icons";

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="border-t border-[#1A2919]/10 bg-[#F6F4ED] pt-16 pb-12 relative text-xs text-[#1A2919]">
      <div className="max-w-7xl mx-auto px-6">
        
        {/* Top Directory Grid */}
        <div className="grid grid-cols-1 md:grid-cols-12 gap-12 pb-12 border-b border-[#1A2919]/10">
          
          {/* Column 1: Brand & Left-Aligned Scan to Install Badge */}
          <div className="md:col-span-5 space-y-5">
            <Link href="/" className="flex items-center gap-3 group">
              <div className="relative w-9 h-9 rounded-full overflow-hidden border border-[#1A2919]/10 shadow-sm bg-white flex items-center justify-center">
                <Image
                  src="/logo.png"
                  alt="KrishiOS Logo"
                  width={36}
                  height={36}
                  className="object-cover"
                />
              </div>
              <span className="text-xl font-bold tracking-tight text-[#1A2919] text-serif-editorial">
                KrishiOS
              </span>
            </Link>

            <p className="text-[#4B5E4A] text-xs leading-relaxed max-w-sm">
              AI-powered agriculture platform delivering instant offline crop disease diagnostics, local ONNX edge inference, and multi-lingual voice guidance.
            </p>

            <div className="flex items-center gap-2 text-[10px] text-[#233B22] bg-[#233B22]/10 px-3 py-1 rounded-full border border-[#233B22]/20 w-fit font-bold font-mono">
              <ShieldCheck className="w-3.5 h-3.5 text-[#233B22]" />
              <span>PRODUCTION RELEASE CANDIDATE 1</span>
            </div>

            {/* Left-Aligned QR Code Scan Badge in Deep Forest Olive Brand Palette */}
            <div className="p-4 rounded-2xl bg-[#233B22] text-[#F6F4ED] flex items-center gap-4 border border-[#233B22]/30 shadow-lg max-w-sm">
              <div className="w-16 h-16 bg-white p-1.5 rounded-xl flex items-center justify-center shrink-0 border border-white/20">
                {/* SVG QR Code Pattern in Deep Forest Olive (#233B22) */}
                <svg viewBox="0 0 100 100" className="w-full h-full fill-[#233B22]">
                  <rect x="0" y="0" width="30" height="30" rx="4" />
                  <rect x="5" y="5" width="20" height="20" fill="white" rx="2" />
                  <rect x="10" y="10" width="10" height="10" />
                  <rect x="70" y="0" width="30" height="30" rx="4" />
                  <rect x="75" y="5" width="20" height="20" fill="white" rx="2" />
                  <rect x="80" y="10" width="10" height="10" />
                  <rect x="0" y="70" width="30" height="30" rx="4" />
                  <rect x="5" y="75" width="20" height="20" fill="white" rx="2" />
                  <rect x="10" y="80" width="10" height="10" />
                  <rect x="40" y="40" width="20" height="20" rx="2" />
                  <rect x="70" y="70" width="15" height="15" rx="2" />
                  <rect x="40" y="70" width="15" height="15" rx="2" />
                  <rect x="70" y="40" width="15" height="15" rx="2" />
                </svg>
              </div>
              <div className="space-y-1">
                <h5 className="font-bold text-sm text-[#F6F4ED]">Scan to install</h5>
                <p className="text-[11px] text-[#A4B8A2]">Point your phone camera here</p>
                <div className="text-[10px] font-mono font-bold tracking-wider text-[#F6F4ED] pt-0.5 uppercase">
                  FREE &middot; ANDROID
                </div>
              </div>
            </div>
          </div>

          {/* Column 2: Navigation */}
          <div className="md:col-span-3 space-y-3 font-medium">
            <h4 className="text-[10px] font-mono uppercase tracking-widest text-[#233B22] font-bold">
              Navigation
            </h4>
            <ul className="space-y-2 text-[#4B5E4A]">
              <li>
                <Link href="/#about" className="hover:text-[#233B22] transition-colors">
                  About Us
                </Link>
              </li>
              <li>
                <Link href="/#problem" className="hover:text-[#233B22] transition-colors">
                  The Problem
                </Link>
              </li>
              <li>
                <Link href="/#features" className="hover:text-[#233B22] transition-colors">
                  Architecture
                </Link>
              </li>
              <li>
                <Link href="/#experience" className="hover:text-[#233B22] transition-colors">
                  Product Experience
                </Link>
              </li>
              <li>
                <Link href="/experience" className="hover:text-[#233B22] transition-colors">
                  Interactive Demo
                </Link>
              </li>
              <li>
                <Link href="/#download" className="hover:text-[#233B22] transition-colors">
                  Download APK
                </Link>
              </li>
              <li>
                <Link href="/#team" className="hover:text-[#233B22] transition-colors">
                  Team 4 Brain
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 3: Resources & Legal */}
          <div className="md:col-span-4 space-y-3 font-medium">
            <h4 className="text-[10px] font-mono uppercase tracking-widest text-[#233B22] font-bold">
              Resources &amp; Legal
            </h4>
            <ul className="space-y-2 text-[#4B5E4A]">
              <li>
                <a
                  href="https://github.com/biswyaa28/krishios-native-app.git"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-[#233B22] transition-colors flex items-center gap-1.5"
                >
                  <GithubIcon className="w-3.5 h-3.5" />
                  <span>GitHub Repository</span>
                </a>
              </li>
              <li>
                <Link href="/privacy" className="hover:text-[#233B22] transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="hover:text-[#233B22] transition-colors">
                  Terms of Service
                </Link>
              </li>
              <li>
                <Link href="/contact" className="hover:text-[#233B22] transition-colors">
                  Contact Support
                </Link>
              </li>
            </ul>
          </div>

        </div>

        {/* Bottom Rights Bar */}
        <div className="pt-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-[#4B5E4A] font-medium">
          <p>&copy; {currentYear} KrishiOS. All rights reserved.</p>
          <div className="flex items-center gap-6">
            <span className="font-bold text-[#1A2919]">Built by Team 4 Brain</span>
          </div>
        </div>

      </div>
    </footer>
  );
}
