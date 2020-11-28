# deploy commands

# git submodule add  https://github.com/gcushen/hugo-academic.git themes/hugo-academic
# add a gh-pages branch -- https://jiafulow.github.io/blog/2020/07/09/create-gh-pages-branch-in-existing-repo/
# git checkout f075bc2

echo "Deleting old public"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
# upstream/gh-pages origin/gh-pages
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

# find . -name "*.html" -type f -delete
# rm -rf themes/hugo-academic
# git submodule update --recursive --remote
# git submodule update

echo "Generating site"
Rscript -e "blogdown::build_site()"

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

#echo "Pushing to github"
#git push --all
