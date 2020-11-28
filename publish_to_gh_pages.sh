# deploy commands

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
# upstream/gh-pages origin/gh-pages
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

find . -name "*.html" -type f -delete
rm -rf themes/hugo-academic
git submodule update --recursive --remote

echo "Generating site"
Rscript -e "blogdown::build_site()"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

#echo "Pushing to github"
#git push --all
