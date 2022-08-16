function val = class(obj,varargin)
%CLASS Create object or return object class.
%
%   VAL = CLASS(OBJ) returns the class of the object OBJ.
%
%   Within a constructor method, CLASS(S,'class_name') creates an
%   object of class 'class_name' from the structure S.  This
%   syntax is only valid in a function named <class_name>.m in a
%   directory named @<class_name> (where <class_name> is the same
%   as the string passed into CLASS).  
% 
%   See also ISA, SUPERIORTO, INFERIORTO, STRUCT.
%

%   MP 6-25-02
%   Copyright 1999-2008 The MathWorks, Inc. 

% Return the class of the object as specified by the java object.
if nargin==1
    jobj = igetfield(obj, 'jobject');
    val = char(mclass(jobj(1)));
else
   try
      % Constructing the object.  Call the builtin CLASS.
      val = builtin('class', obj, varargin{:});
   catch aException
      rethrow(aException);
   end
end
