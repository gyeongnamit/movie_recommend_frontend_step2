import logo from './logo.svg'; // 로고 이미지를 불러옴
import './App.css'; // CSS 스타일 적용
import React, { useEffect, useState } from "react"; // React 기본 기능 및 훅(hook) 불러옴
import axios from "axios"; // HTTP 요청을 위한 라이브러리 axios 불러옴

// 메인 컴포넌트 정의
function App() {
  // 최신 영화 목록을 저장할 state 변수 선언 (초기값: 빈 배열)
  const [latestMovies, setLatestMovies] = useState([]); 
  // 인기 영화 목록을 저장할 state 변수 선언 (초기값: 빈 배열)
  const [popularMovies, setPopularMovies] = useState([]); 
  
  // 화면이 처음 렌더링될 때 실행 (의존성 배열이 빈 상태라 한 번만 실행됨)
  useEffect(() => {
    // 최신 영화 목록 요청 (백엔드 API 호출)
    axios.get("/movie/movie_latest").then((response) => {
      console.log("latest", response.data); // 콘솔에 최신 영화 데이터 출력
      setLatestMovies(response.data); // 최신 영화 데이터를 state에 저장
    });

    // 인기 영화 목록 요청 (백엔드 API 호출)
    axios.get("/movie/movie_popular").then((response) => {
      console.log("popular", response.data); // 콘솔에 인기 영화 데이터 출력
      setPopularMovies(response.data); // 인기 영화 데이터를 state에 저장
    });
  }, []); // 의존성 배열이 비어 있으므로 처음 렌더링 시 한 번만 실행됨

  // 화면에 출력할 HTML 구조 정의
  return (
    <div className="App"> {/* 최상위 div로 App 전체를 감쌈 */}
      <h1>Movies </h1> {/* 메인 제목 */}

      {/* 최신 영화 섹션 */}
      <section>
        <h2>Latest Movies</h2>
        <div className="movie-grid"> {/* 최신 영화 목록을 그리드 형태로 출력 */}
          {latestMovies.map((movie) => ( // 최신 영화 목록 반복 출력
            <div key={movie.num} className="movie-card"> {/* 각 영화 카드 생성 */}
              <img src={movie.poster} alt={movie.title} className="poster" /> {/* 영화 포스터 출력 */}
              <div className="movie-info"> {/* 영화 정보 표시 */}
                <h3>{movie.title}</h3> {/* 영화 제목 출력 */}
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* 인기 영화 섹션 */}
      <section>
        <h2>Popular Movies</h2>
        <div className="movie-grid"> {/* 인기 영화 목록을 그리드 형태로 출력 */}
          {popularMovies.map((movie) => ( // 인기 영화 목록 반복 출력
            <div key={movie.num} className="movie-card"> {/* 각 영화 카드 생성 */}
              <img src={movie.poster} alt={movie.title} className="poster" /> {/* 영화 포스터 출력 */}
              <div className="movie-info"> {/* 영화 정보 표시 */}
                <h3>{movie.title}</h3> {/* 영화 제목 출력 */}
              </div>
            </div>
          ))}
        </div>
      </section>

    </div>
  );
}

export default App; // 이 컴포넌트를 다른 파일에서 사용할 수 있도록 내보냄