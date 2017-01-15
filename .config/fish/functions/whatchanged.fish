function whatchanged -a repo range
  open https://github.com/$repo/compare/master@\{$range\}...master
end

