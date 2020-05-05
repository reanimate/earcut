#include <stdio.h>
#include "earcut.hpp"

using Coord = double;
using N = uint32_t;
using Point = std::array<Coord, 2>;

extern "C" {
  void earcut(Coord* polygon, int polygonSize, N** trigs, unsigned long int * trigSize) {
    std::vector<std::vector<Point>> c;
    std::vector<Point> p;
    for(int i=0;i<polygonSize/2;i++) {
      p.push_back({polygon[i*2], polygon[i*2+1]});
    }
    c.push_back(p);
    std::vector<N> indices = mapbox::earcut<N>(c);
    *trigSize = (int)indices.size();
    *trigs = (N*)malloc(indices.size() * sizeof(Coord));
    for(unsigned long int i=0;i<indices.size();i++) {
      (*trigs)[i] = indices[i];
    }
    return;
  }

}
