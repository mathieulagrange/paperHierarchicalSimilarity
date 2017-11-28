function [intra, inter] = energy(S, c)

if min(c)==0
    c=c+1;
end
nbc = max(unique(c));

intra = zeros(1, nbc);
inter = zeros(1, nbc);
for k=1:size(S, 1)
    for l=k+1:size(S, 1)
      if c(k)==c(l)
          intra(c(k)) = intra(c(k)) + S(k, l);
      else
        inter(c(k)) = inter(c(k)) + S(k, l);         
      end
    end
end
intra(intra==0) = [];
intra=mean(intra);
inter(inter==0) = [];
inter=mean(inter);