## Copyright (C) 2026 Tang Chonghao <chadholton@qq.com>
##
## This file is part of the fuzzy-logic-toolkit.
##
## The fuzzy-logic-toolkit is free software; you can redistribute it
## and/or modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 3 of
## the License, or (at your option) any later version.
##
## The fuzzy-logic-toolkit is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the fuzzy-logic-toolkit; see the file COPYING.  If not,
## see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{y} =} probor (@var{x})
## Compute the probabilistic OR (algebraic sum) of input @var{x}.
##
## @var{x} — Fuzzy input values, specified as a numeric array where each row
## represents a membership function and columns represent input values. For
## a single row vector, @var{x} is returned unchanged. Input values should
## normally be in [0, 1] for fuzzy logic operations. Values outside this
## range will not trigger errors, but the results will not represent valid
## membership degrees.
##
## @var{y} — Probabilistic OR values, returned as a row vector with the same
## number of columns as @var{x}.
##
## @strong{Algorithm:}
##
## For two-row input @qcode{x = [A; B]}, the result is calculated as:
## @example
## y(i) = A(i) + B(i) - A(i) * B(i);
## @end example
##
## For input with more than two rows, the operation is performed sequentially:
## @example
## x = [A; B; C]
## y(i) = A(i) + B(i) - A(i) * B(i);
## y(i) = y(i) + C(i) - y(i) * C(i);
## @end example
##
## @end deftypefn

function y = probor (x)

  if (nargin != 1)
    print_usage ();
  endif

  ## Input validation
  if (! isnumeric (x) || ! isreal (x) || isempty (x))
    error ("probor: X must be a non-empty numeric array.");
  endif

  if (isrow (x))
    y = x;
  else
    ## Initialize result with first row
    y = x(1, :);

    ## Sequentially apply probabilistic OR
    for i = 2:rows (x)
      y = y + x(i, :) - y .* x(i, :);
    endfor
  endif
endfunction

%!test
%! % Single row input should return unchanged
%! x = [0.2 0.4 0.6];
%! y = probor(x);
%! assert(y, x, eps);

%!test
%! % Single column input should calculate
%! x = [0.2; 0.4; 0.6];
%! y = probor(x);
%! assert(y, 0.8080, eps);

%!test
%! A = [0.2 0.4 0.6];
%! B = [0.3 0.5 0.7];
%! expected = A + B - A .* B;
%! y = probor([A; B]);
%! assert(y, expected, eps);

%!test
%! A = [0.1 0.2];
%! B = [0.3 0.4];
%! C = [0.5 0.6];
%! temp = A + B - A .* B;
%! expected = temp + C - temp .* C;
%! y = probor([A; B; C]);
%! assert(y, expected, eps);

%!error <X must be a non-empty numeric array.> probor([]);
%!error <X must be a non-empty numeric array.> probor("string");
