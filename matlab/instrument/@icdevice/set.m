function outputStruct = set(obj, varargin)
%SET Configure or display instrument object properties.
%
%   SET(OBJ,'PropertyName',PropertyValue) sets the value, PropertyValue,
%   of the specified property, PropertyName, for instrument object OBJ.
%
%   OBJ can be a vector of instrument objects, in which case SET sets the
%   property values for all the instrument objects specified.
%
%   SET(OBJ,S) where S is a structure whose field names are object property 
%   names, sets the properties named in each field name with the values 
%   contained in the structure.
%
%   SET(OBJ,PN,PV) sets the properties specified in the cell array of
%   strings, PN, to the corresponding values in the cell array PV for all
%   objects specified in OBJ. The cell array PN must be a vector, but the 
%   cell array PV can be M-by-N where M is equal to length(OBJ) and N is
%   equal to length(PN) so that each object will be updated with a different
%   set of values for the list of property names contained in PN.
%
%   SET(OBJ,'PropertyName1',PropertyValue1,'PropertyName2',PropertyValue2,...)
%   sets multiple property values with a single statement. Note that it
%   is permissible to use param-value string pairs, structures, and
%   param-value cell array pairs in the same call to SET.
%
%   SET(OBJ, 'PropertyName') 
%   PROP = SET(OBJ,'PropertyName') displays or returns the possible values
%   for the specified property, PropertyName, of instrument object OBJ. 
%   The returned array, PROP, is a cell array of possible value strings  
%   or an empty cell array if the property does not have a finite set of
%   possible string values.
%   
%   SET(OBJ) 
%   PROP = SET(OBJ) displays or returns all property names and their
%   possible values for instrument object OBJ. The return value, PROP, is
%   a structure whose field names are the property names of OBJ, and whose 
%   values are cell arrays of possible property values or empty cell arrays.
%
%   Example:
%       g = gpib('ni', 0, 2);
%       set(g, 'EOSCharCode', 'CR', 'EOSMode', 'read');
%       set(g, {'RecordMode', 'RecordName'}, {'index', 'sydney.txt'});
%       set(g, 'Name', 'MyGPIBObject');
%       set(g, 'RecordDetail')
%
%   See also INSTRUMENT/GET, INSTRUMENT/PROPINFO, INSTRHELP.
%

%   Copyright 1999-2016 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Call builtin set if OBJ isn't an instrument object.
% Ex. set(s, 'UserData', s);
if ~isa(obj, 'instrument')
    try
	    builtin('set', obj, varargin{:});
    catch aException
        rethrow(aException);
    end
    return;
end

% Error if invalid.
if ~all(isvalid(obj))
   error(message('instrument:set:invalidOBJ'));
end

if (nargout == 0)
   % Ex. set(obj)
   if nargin == 1
      if (length(obj) == 1)
         localCreateSetDisplay(obj);
         return;
      else
         error(message('instrument:set:nolhswithvector'));
      end
   else
      % Ex. set(obj, 'BaudRate');
      % Ex. set(obj, 'BaudRate', 4800);
      try
         % Call the java set method.
         if (nargin == 2)
            if ischar(varargin{1}) 
                % Ex. set(obj, 'RecordMode')
                if (length(obj) > 1)
                    error(message('instrument:set:scalarHandle'));
                end
				disp(char(createPropSetDisplay(java(igetfield(obj, 'jobject')), varargin(1))));
            elseif isstruct(varargin{1})
                % Ex. set(obj, struct);
                tempObj = igetfield(obj, 'jobject');
            	set(tempObj, varargin{:});
            else
                error(message('instrument:set:invalidPVPair'));
            end
         else
            % Ex. set(obj, 'BaudRate', 4800); 
            tempObj = igetfield(obj, 'jobject');
            set(tempObj, varargin{:});
         end
      catch aException
          localFixError(aException);
      end
   end
else
   % Ex. out = set(obj);
   % Ex. out = set(obj, 'BaudRate');
   try
      % Call the java set method.
	  switch nargin 
	  case 1
          % Ex. out = set(obj);
          if (length(obj) > 1)
              error(message('instrument:set:scalarHandleLength'));
          end
          outputStruct = localCreateOutputStruct(obj);
      case 2
		  % Ex. out = set(obj, 'BaudRate')
          if (length(obj) > 1)
              error(message('instrument:set:scalarHandle'));
          end
		  if ~ischar(varargin{1})
			  % Ex. out = set(obj, {'BaudRate', 'Parity'});
			  error(message('instrument:set:invalidPVPair'));
		  end
		  outputStruct = cell(createPropSetArray(java(igetfield(obj, 'jobject')), varargin{1}));
	  case 3
		  % Ex. out = set(obj, 'BaudRate', 9600)
          set(igetfield(obj, 'jobject'), varargin{:});
      end
   catch aException
       localFixError(aException);
   end
end

% ----------------------------------------------------------------------
% Create the structure returned by out = SET(OBJ).
function out = localCreateOutputStruct(deviceObj)

% Get the java object.
obj = igetfield(deviceObj, 'jobject');

% Find the settable properties.
for j = 1:length(obj)
    % Get the property names.
    jobj = java(obj(j));
    names = com.mathworks.toolbox.instrument.device.util.PropertyUtil.getSettable(jobj);
    names(cellfun('isempty', names)) = [];

    % Get the property values.
    vals = cell(1, length(names));
    for i = 1:length(names)
        vals{i} = cell(createPropSetArray(jobj, names{i}));
    end

    % Combine property names and values into a structure.
    out(j, 1) = cell2struct(vals, names, 2);
end

% ----------------------------------------------------------------------
% Create the display for SET(OBJ)
function localCreateSetDisplay(obj)

fprintf(char(setDisplay(igetfield(obj, 'jobject'))));

% ----------------------------------------------------------------------
% Fix the error message.
function localFixError (exception)

% Initialize variables.
id = exception.identifier;
out = exception.message;

if findstr('com.mathworks.toolbox.instrument.device.', out)
    out = strrep(out, sprintf('com.mathworks.toolbox.instrument.device.'), '');
end

if findstr('javahandle.', out)
	out = strrep(out, sprintf('javahandle.'), '');
end

if findstr('ICDevice', out)
   out = strrep(out, localFindJavaName(out), 'device objects');
   out = strrep(out, 'in the device objects class', 'for device objects');
end

% Remove the trailing carriage returns from errmsg.
while out(end) == sprintf('\n')
   out = out(1:end-1);
end

if isempty(id) || ~isempty(findstr(id, 'MATLAB:class:'))
    id = 'instrument:set:opfailed';
end

newExc = MException(id, out);
throwAsCaller(newExc);


% ----------------------------------------------------------------------
% Find the device object java name.
function name = localFindJavaName(msg)

startIndex = findstr('ICDevice', msg);
startIndex = startIndex(1);
spaceIndex = findstr(msg, ' ');
temp       = find(spaceIndex > startIndex);
if (~isempty(temp))
    temp       = temp(1);
    endIndex   = spaceIndex(temp);
else
    endIndex = length(msg);
end

name = msg(startIndex-1:endIndex-1);
name = strrep(name, ' ', '');
