// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
    purge: [
        "../**/*.html.eex",
        "../**/*.html.leex",
        "../**/views/**/*.ex",
        "../**/live/**/*.ex",
        "./js/**/*.js"
    ],
    theme: {
        extend: {
            colors: {
                neon: '#3aff38'
            },
            fontFamily: {
                sans: ['Orbitron', ...defaultTheme.fontFamily.sans],
            },
            fontSize: {
                '8xl': '6rem',
            }
        },
    },
    variants: {},
    plugins: [
        require('@tailwindcss/ui'),
    ],
}
