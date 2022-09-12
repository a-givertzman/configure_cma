import 'dart:typed_data';

///
/// Provide creating of bmp from RGB array
class BmpRender {
  final int _width; // NOTE: width must be multiple of 4 as no account is made for bitmap padding
  final int _height;
  final Uint8List _bitmap;
  // int _totalHeaderSize;
  ///
  BmpRender({
    required int width, 
    required int height,
    required Uint8List bitmap,
  }) : 
    // assert(width & 3 == 0),
    _width = width,
    _height = height,
    _bitmap = bitmap;
  /// Insert the provided bitmap after the header and return the whole BMP
  Uint8List bmp() {
    final int size = _width * _height;
    // assert(_bitmap.length == size);
    const baseHeaderSize = 54;
    const totalHeaderSize = baseHeaderSize + 1024; // base + color map
    final bmp = _prepareHeader(
      baseHeaderSize: baseHeaderSize,
      totalHeaderSize: totalHeaderSize,
    );
    bmp.setRange(totalHeaderSize, totalHeaderSize + size, _bitmap);
    return bmp;
  }
  ///
  Uint8List _prepareHeader({
    required int baseHeaderSize, 
    required int totalHeaderSize,
  }) {
    final int fileLength = totalHeaderSize + _width * _height; // header + bitmap
    final bmp = Uint8List(fileLength);
    final ByteData bd = bmp.buffer.asByteData();
    bd.setUint8(0, 0x42);
    bd.setUint8(1, 0x4d);
    bd.setUint32(2, fileLength, Endian.little); // file length
    bd.setUint32(10, totalHeaderSize, Endian.little); // start of the bitmap
    bd.setUint32(14, 40, Endian.little); // info header size
    bd.setUint32(18, _width, Endian.little);
    bd.setUint32(22, _height, Endian.little);
    bd.setUint16(26, 1, Endian.little); // planes
    bd.setUint32(28, 8, Endian.little); // bpp
    bd.setUint32(30, 0, Endian.little); // compression
    bd.setUint32(34, _width * _height, Endian.little); // bitmap size
    // leave everything else as zero
    // there are 256 possible variations of pixel
    // build the indexed color map that maps from packed byte to RGBA32
    // better still, create a lookup table see: http://unwind.se/bgr233/
    for (int rgb = 0; rgb < 256; rgb++) {
      final int offset = baseHeaderSize + rgb * 4;
      final int red = rgb & 0xe0;
      final int green = rgb << 3 & 0xe0;
      final int blue = rgb & 6 & 0xc0;
      bd.setUint8(offset + 3, 255); // A
      bd.setUint8(offset + 2, red); // R
      bd.setUint8(offset + 1, green); // G
      bd.setUint8(offset, blue); // B
    }
    return bmp;
  }
}
