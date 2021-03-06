% STK_BOUNDINGBOX [overload STK function, deprecated]
%
% DEPRECATION WARNING: The use of .a structures is deprecated.

% Copyright Notice
%
%    Copyright (C) 2015, 2016 CentraleSupelec
%
%    Author:  Julien Bect  <julien.bect@centralesupelec.fr>

% Copying Permission Statement
%
%    This file is part of
%
%            STK: a Small (Matlab/Octave) Toolbox for Kriging
%               (http://sourceforge.net/projects/kriging)
%
%    STK is free software: you can redistribute it and/or modify it under
%    the terms of the GNU General Public License as published by the Free
%    Software Foundation,  either version 3  of the License, or  (at your
%    option) any later version.
%
%    STK is distributed  in the hope that it will  be useful, but WITHOUT
%    ANY WARRANTY;  without even the implied  warranty of MERCHANTABILITY
%    or FITNESS  FOR A  PARTICULAR PURPOSE.  See  the GNU  General Public
%    License for more details.
%
%    You should  have received a copy  of the GNU  General Public License
%    along with STK.  If not, see <http://www.gnu.org/licenses/>.

function box = stk_boundingbox (x)

if nargin > 1,
    stk_error ('Too many input arguments.', 'TooManyInputArgs');
end

if ~ isfield (x, 'a')
    % The "modern STK" answer is:
    stk_error (['stk_boundingbox (x) is not defined for structure ' ...
        'arguments.'], 'TypeMismatch');
else
    % But for backward compatibility we still support:
    box = stk_boundingbox (x.a);
end

end % function


%!shared x, y, cn
%! cn = {'a', 'b', 'c'};
%! x = struct ('a', [0 3 2; 1 4 1; 7 0 2]);

%!error  y = stk_boundingbox ();
%!test   y = stk_boundingbox (x);
%!error  y = stk_boundingbox (x, 1);

%!assert (isequal (y.data, [0 0 1; 7 4 2]));
