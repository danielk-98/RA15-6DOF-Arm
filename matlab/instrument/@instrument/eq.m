function iseq=eq(arg1, arg2)
%EQ Overload of == for instrument objects.
%

%   MP 7-13-99
%   Copyright 1999-2009 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2011/05/13 18:06:06 $


% Warn appropriately if one of the input arguments is empty.
if isempty(arg1)
    if (length(arg2) == 1)
       iseq = [];
   else
       error(message('instrument:eq:dimagree'));
   end
   return;
elseif isempty(arg2)
   if (length(arg1) == 1)
       iseq = [];
   else
       error(message('instrument:eq:dimagree'));
   end
   return;
end

% Determine if both objects are instrument objects.
try   
   % Initialize variables.
   jarg1 = igetfield(arg1, 'jobject');
   jarg2 = igetfield(arg2, 'jobject');

   % Error if both the objects have a length greater than 1 and have
   % different sizes.
   sizeOfArg1 = size(jarg1); 
   sizeOfArg2 = size(jarg2); 
   
   if (numel(jarg1)~=1) && (numel(jarg2)~=1)
      if ~(all(sizeOfArg1 == sizeOfArg2)) 
         error(message('instrument:eq:dimagree'))
      end
   end
  
   iseq = (jarg1 == jarg2);
catch aException
    % Rethrow error from above.
    if strcmp(aException.identifier, 'instrument:eq:dimagree')
        rethrow(aException);
    end
    
   % One of the object's is not an instrument object and therefore unequal.
   % Error if both the objects have a length greater than 1 and have
   % different sizes.    
   if prod(size(arg1))~=1 && prod(size(arg2))~=1
       if size(arg1,1)~=size(arg2,1) || size(arg1,2)~=size(arg2,2)
          error(message('instrument:eq:dimagree'))
      end
   end
   
   % Return a logical zero. 
   if length(arg1) ~= 1
       iseq = zeros(size(arg1));
   else
       iseq = zeros(size(arg2));
   end
end

iseq = logical(iseq);