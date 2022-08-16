function out = length(obj)
%LENGTH Length of device group object array.
%
%   LENGTH(OBJ) returns the length of device group object array, OBJ.
%   It is equivalent to MAX(SIZE(OBJ)).  
%    
%   See also ICGROUP/SIZE, INSTRHELP.
%

%   MP 6-25-02
%   Copyright 1999-2004 The MathWorks, Inc. 


% The jobject property of the object indicates the number of 
% objects that are concatenated together.
try
   out = builtin('length', obj.jobject);
catch
   out = 1;
end




