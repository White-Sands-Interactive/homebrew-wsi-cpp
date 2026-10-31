class WsiAgentPlayer < Formula
  desc "C++ SDK for White Sands agent players"
  homepage "https://github.com/White-Sands-Interactive/WSI-Cpp"
  url "https://github.com/White-Sands-Interactive/WSI-Cpp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f236f2a9eaa40c98f5f9acdf38b02d7fbafded5cc9b92dedf686116f73c3e8fc"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "nlohmann-json"
  depends_on "openssl@3"
  depends_on "sqlite"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DWSI_EMBEDDED=ON",
           "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <wsi/protocol.hpp>
      int main() { return wsi::kProtocolVersion == 1 ? 0 : 1; }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-o", "test"
    system "./test"
  end
end
