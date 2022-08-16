function obj = ctranspose(obj)
%' Complex conjugate transpose.   
% 
%   B = CTRANSPOSE(OBJ) is called for the syntax OBJ' (complex conjugate
%   transpose) when OBJ is an instrument object array.
%

%   MP 7-13-99
%   Copyright 1999-2009 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2009/10/16 06:39:27 $

% Transpose the jobject vector.
jobject = igetfield(obj, 'jobject');
obj = isetfield(obj, 'jobject', jobject');