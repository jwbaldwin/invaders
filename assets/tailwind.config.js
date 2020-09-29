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
                'neon-green': '#00d13e',
                'neon-yellow': '#eab300',
                'neon-orange': '#de5e00'
            },
            fontFamily: {
                sans: ['VT323', ...defaultTheme.fontFamily.sans],
            },
            fontSize: {
                '8xl': '6rem',
                '9xl': '9rem',
                '10xl': '10rem'
            }
        },
    },
    variants: {},
    plugins: [
        require('@tailwindcss/ui'),
    ],
}
