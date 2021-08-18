#include <algorithm>
#include <iostream>
#include <string>

static inline void rtrim(std::string &s) {
  s.erase(std::find_if(s.rbegin(), s.rend(),
                       [](unsigned char ch) { return !std::isspace(ch); })
              .base(),
          s.end());
}

int main() {
  for (std::string line; std::getline(std::cin, line);) {
    rtrim(line);
    if (line == "q")
      break;
    std::cout << "Input: " << line << std::endl;
  }
}
