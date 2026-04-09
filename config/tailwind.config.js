const defaultTheme = require('tailwindcss/defaultTheme')
const execSync = require('child_process').execSync;
const output = execSync('bundle show tybo', { encoding: 'utf-8' });


module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{erb,haml,html,rb}',
    output.trim() + '/app/**/*.{erb,haml,html,rb}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      screens: {
        sm: '0px',
        md: '768px',
        lg: '976px',
        xl: '1440px',
      },
      colors: {
        tybo: {
          DEFAULT: '#581c87',
          '50': '#fbf5ff',
          '100': '#f5e8ff',
          '200': '#edd5ff',
          '300': '#ddb4fe',
          '400': '#c784fc',
          '500': '#b055f7',
          '600': '#9a33ea',
          '700': '#8222ce',
          '800': '#6d21a8',
          '900': '#581c87',
          '950': '#3b0764',
        },
        'red-alert': {
          DEFAULT: '#d0342c',
          '50': '#fdf3f3',
          '100': '#fde4e3',
          '200': '#fbcfcd',
          '300': '#f8ada9',
          '400': '#f17e78',
          '500': '#e7544c',
          '600': '#d0342c',
          '700': '#b12b24',
          '800': '#932721',
          '900': '#7a2622',
          '950': '#42100d',
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
