library graph_paper.utilties;


String pixelsToString ( num pixels ) {

	return pixels.toString() + 'px';

}

num stringToPixels ( String pixels_string ) {

	return int.parse( pixels_string.replaceAll( 'px', '' ) );

}