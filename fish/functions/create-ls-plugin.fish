function create-ls-plugin
	if [ $argv[1] = "react" ]
		echo "Creating react plugin"
		mkdir $argv[2]
		cd $argv[2]
		yarn add @logseq/libs react react-dom tailwindcss && yarn add parcel @types/react @types/react-dom @types/node postcss postcss-cli cssnano --dev
		mkdir src
		touch src/index.tsx
		touch src/index.html
		touch .postcssrc
		echo {"plugins":{"tailwindcss":{},"cssnano":{}}} > .postcssrc
		touch tailwind.config.js
		echo module.exports={content:["./src/**/*.{vue,js,ts,jsx,tsx,hbs,html}"],theme:{extend:{spacing:{100:"50rem"}}}} > tailwind.config.js
		sed -i '' '2i\
		"logseq":{"id": "'$argv[2]'","title":"'$argv[2]'","icon":"./icon.svg"},"name":"'$argv[2]'","main":"dist/index.html","targets":{"main":false},' package.json
	else
		echo "Creating non-react plugin"
		mkdir $argv[2]
		cd $argv[2]
		yarn add @logseq/libs && yarn add parcel --dev
		mkdir src
		touch src/index.tsx
		touch src/index.html
		sed -i '' '2i\
		"logseq":{"id": "'$argv[2]'","title":"'$argv[2]'","icon":"./icon.svg"},"name":"'$argv[2]'","main":"dist/index.html","targets":{"main":false},' package.json
	end
end
