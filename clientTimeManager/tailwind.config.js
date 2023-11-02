const colors = require('tailwindcss/colors')

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
    colors: {
      customPrimary: 'var(--primary-blue)',
      customSecondary: 'var(--secondary-pink)',
      darkPrimary: 'var(--primary-blue-dark)',
      customGrey: 'var(--grey)', 
      ...colors
    }
  },
  plugins: [],
}

