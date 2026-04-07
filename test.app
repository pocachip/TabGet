import React, { useState, useEffect, useCallback, useRef } from 'react'; import { Heart, Users, ChevronLeft, ChevronRight, Trophy, Smartphone, RotateCw, Volume2 } from 'lucide-react';
const VS_DATA = [ { id: 1, itemA: "프리미엄 무선 이어폰", itemB: "최신형 스마트워치", colorA: "bg-blue-900", colorB: "bg-indigo-900", imgA: "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&q=80&w=800", imgB: "https://images.unsplash.com/photo-1544117518-30dd5ff7a4b0?auto=format&fit=crop&q=80&w=800", votesA: 12450, votesB: 11820 }, { id: 2, itemA: "화이트 스니커즈", itemB: "어글리 슈즈", colorA: "bg-gray-800", colorB: "bg-slate-800", imgA: "https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&q=80&w=800", imgB: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=800", votesA: 8900, votesB: 9200 }, { id: 3, itemA: "아이스 아메리카노", itemB: "따뜻한 카페라떼", colorA: "bg-amber-900", colorB: "bg-orange-900", imgA: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80&w=800", imgB: "https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&q=80&w=800", votesA: 15600, votesB: 14200 }, { id: 4, itemA: "고성능 게이밍 폰", itemB: "휴대용 게임 콘솔", colorA: "bg-red-900", colorB: "bg-zinc-900", imgA: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&q=80&w=800", imgB: "https://images.unsplash.com/photo-1605898835373-03f395f87e22?auto=format&fit=crop&q=80&w=800", votesA: 7800, votesB: 8500 }, { id: 5, itemA: "럭셔리 세단", itemB: "강력한 SUV", colorA: "bg-neutral-900", colorB: "bg-stone-900", imgA: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=800", imgB: "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&q=80&w=800", votesA: 21000, votesB: 19500 }, ];
const App = () => { const [isPortrait, setIsPortrait] = useState(true); const [currentIndex, setCurrentIndex] = useState(0); const [votedSide, setVotedSide] = useState(null); // 'A', 'B', or null const [showHeart, setShowHeart] = useState({ active: false, x: 0, y: 0 }); const [isWinnerRevealed, setIsWinnerRevealed] = useState(false); const lastTapRef = useRef(0);
const currentSet = VS_DATA[currentIndex];
// Double Tap Logic const handleTap = (side, e) => { const now = Date.now(); const DOUBLE_TAP_DELAY = 300;
if (now - lastTapRef.current < DOUBLE_TAP_DELAY) {
  // Double tap detected
  setVotedSide(side);
  const rect = e.currentTarget.getBoundingClientRect();
  setShowHeart({
    active: true,
    x: e.clientX || (rect.left + rect.width / 2),
    y: e.clientY || (rect.top + rect.height / 2)
  });
  
  setTimeout(() => setShowHeart({ ...showHeart, active: false }), 800);
  
  // Simulate winner reveal after voting
  setTimeout(() => setIsWinnerRevealed(true), 2000);
}
lastTapRef.current = now;
};
const nextSet = () => { setVotedSide(null); setIsWinnerRevealed(false); setCurrentIndex((prev) => (prev + 1) % VS_DATA.length); };
const prevSet = () => { setVotedSide(null); setIsWinnerRevealed(false); setCurrentIndex((prev) => (prev - 1 + VS_DATA.length) % VS_DATA.length); };
return ( <div className="flex flex-col items-center justify-center min-h-screen bg-black text-white font-sans overflow-hidden">
  {/* Control Panel (For Demo) */}
  <div className="fixed top-4 z-50 flex gap-2">
    <button 
      onClick={() => setIsPortrait(!isPortrait)}
      className="flex items-center gap-2 px-4 py-2 bg-white/10 backdrop-blur-md rounded-full border border-white/20 hover:bg-white/20 transition"
    >
      {isPortrait ? <Smartphone size={18} /> : <RotateCw size={18} />}
      {isPortrait ? "가로 모드로 보기" : "세로 모드로 보기"}
    </button>
  </div>

  {/* Main Device Container */}
  <div className={`relative transition-all duration-500 shadow-2xl overflow-hidden
    ${isPortrait ? 'w-[375px] h-[667px] rounded-[40px] border-[8px] border-zinc-800' : 'w-[667px] h-[375px] rounded-[40px] border-[8px] border-zinc-800'}`}>
    
    {/* App Content */}
    <div className={`flex w-full h-full ${isPortrait ? 'flex-col' : 'flex-row'}`}>
      
      {/* Section A */}
      <div 
        className={`relative flex-1 overflow-hidden transition-all duration-500 cursor-pointer group
          ${isWinnerRevealed && votedSide === 'B' ? 'opacity-40 grayscale' : 'opacity-100'}`}
        onClick={(e) => handleTap('A', e)}
      >
        <img src={currentSet.imgA} alt={currentSet.itemA} className="absolute inset-0 w-full h-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
        
        {/* Info Overlay */}
        <div className="absolute bottom-6 left-6 right-6">
          <h3 className="text-xl font-bold drop-shadow-md">{currentSet.itemA}</h3>
          <div className="flex items-center gap-2 mt-1 text-sm text-white/80">
            <Users size={14} />
            <span>{currentSet.votesA.toLocaleString()}명 참여 중</span>
          </div>
        </div>

        {/* Winner Badge */}
        {isWinnerRevealed && votedSide === 'A' && (
          <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
            <div className="bg-yellow-500 text-black px-6 py-2 rounded-full font-black text-2xl flex items-center gap-2 animate-bounce shadow-xl">
              <Trophy size={28} /> WINNER
            </div>
          </div>
        )}
        
        {/* Audio Icon (Mute Off indicator) */}
        <div className="absolute top-12 left-6 bg-black/40 p-2 rounded-full backdrop-blur-sm border border-white/10">
          <Volume2 size={16} />
        </div>
      </div>

      {/* VS Divider */}
      <div className={`absolute z-10 bg-white text-black font-black flex items-center justify-center shadow-xl
        ${isPortrait 
          ? 'w-12 h-12 rounded-full left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2' 
          : 'w-12 h-12 rounded-full left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2'}`}>
        VS
      </div>

      {/* Section B */}
      <div 
        className={`relative flex-1 overflow-hidden transition-all duration-500 cursor-pointer group
          ${isWinnerRevealed && votedSide === 'A' ? 'opacity-40 grayscale' : 'opacity-100'}`}
        onClick={(e) => handleTap('B', e)}
      >
        <img src={currentSet.imgB} alt={currentSet.itemB} className="absolute inset-0 w-full h-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
        
        {/* Info Overlay */}
        <div className="absolute bottom-6 left-6 right-6">
          <h3 className="text-xl font-bold drop-shadow-md">{currentSet.itemB}</h3>
          <div className="flex items-center gap-2 mt-1 text-sm text-white/80">
            <Users size={14} />
            <span>{currentSet.votesB.toLocaleString()}명 참여 중</span>
          </div>
        </div>

        {/* Winner Badge */}
        {isWinnerRevealed && votedSide === 'B' && (
          <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
            <div className="bg-yellow-500 text-black px-6 py-2 rounded-full font-black text-2xl flex items-center gap-2 animate-bounce shadow-xl">
              <Trophy size={28} /> WINNER
            </div>
          </div>
        )}

        {/* Audio Icon */}
        <div className={`absolute ${isPortrait ? 'top-12 right-6' : 'top-12 right-6'} bg-black/40 p-2 rounded-full backdrop-blur-sm border border-white/10`}>
          <Volume2 size={16} />
        </div>
      </div>

      {/* Swipe/Nav Overlay */}
      <div className="absolute bottom-12 left-0 right-0 flex justify-between px-4 pointer-events-none">
        <button 
          onClick={(e) => { e.stopPropagation(); prevSet(); }}
          className="w-10 h-10 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center pointer-events-auto hover:bg-white/40 transition"
        >
          <ChevronLeft size={24} />
        </button>
        <div className="flex gap-2 items-center">
          {VS_DATA.map((_, i) => (
            <div key={i} className={`w-2 h-2 rounded-full transition-all ${i === currentIndex ? 'bg-white w-4' : 'bg-white/40'}`} />
          ))}
        </div>
        <button 
          onClick={(e) => { e.stopPropagation(); nextSet(); }}
          className="w-10 h-10 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center pointer-events-auto hover:bg-white/40 transition"
        >
          <ChevronRight size={24} />
        </button>
      </div>

      {/* Participation Toast */}
      {votedSide && !isWinnerRevealed && (
        <div className="absolute bottom-24 left-1/2 -translate-x-1/2 bg-blue-600 text-white px-4 py-2 rounded-lg font-bold animate-pulse shadow-lg z-20">
          참여 완료! 당첨을 기다려주세요 🎁
        </div>
      )}

      {/* Double Tap Heart Animation */}
      {showHeart.active && (
        <div 
          className="fixed pointer-events-none animate-ping z-50 text-red-500"
          style={{ left: showHeart.x - 40, top: showHeart.y - 40 }}
        >
          <Heart size={80} fill="currentColor" />
        </div>
      )}

      {/* Instruction Tooltip */}
      {!votedSide && (
        <div className="absolute top-24 left-1/2 -translate-x-1/2 bg-black/60 backdrop-blur-md px-4 py-2 rounded-full border border-white/20 text-xs font-medium animate-bounce z-20">
          마음에 드는 상품을 <span className="text-yellow-400 font-bold">더블 탭</span> 하세요!
        </div>
      )}
    </div>
  </div>

  <div className="mt-8 text-center max-w-md px-4">
    <p className="text-gray-400 text-sm">
      사용자는 화면을 스와이프하여 다른 경쟁 상품들을 볼 수 있으며, 
      더블 탭을 통해 즉시 경품 이벤트에 응모할 수 있습니다.
    </p>
  </div>
</div>
); };
export default App;
