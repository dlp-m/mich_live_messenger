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
        winxp: ['Franklin Gothic Medium', 'Arial Narrow', 'Arial', 'sans-serif'],
      },
      screens: {
        sm: '0px',
        md: '768px',
        lg: '976px',
        xl: '1440px',
      },
      spacing: {
        taskbar: '42px',
      },
      borderRadius: {
        'winxp-pill': '12px',
      },
      backgroundImage: {
        'winxp-taskbar':     'linear-gradient(to bottom, #245edb 0%, #3b80f0 4%, #2663d9 6%, #1e57cc 50%, #1a4fc0 51%, #1e57cc 100%)',
        'winxp-start':       'linear-gradient(to bottom, #5bb75b 0%, #3da53d 4%, #2e8f2e 40%, #2a862a 50%, #277027 100%)',
        'winxp-tray':        'linear-gradient(to bottom, #1048c0 0%, #1540b8 50%, #0e38a8 100%)',
        'winxp-window-body':     'linear-gradient(to bottom, #8bbad8 0%, #b4d4ec 25%, #d0e8f8 55%, #eaf4fc 80%, #f8fcff 100%)',
        'winxp-win-titlebar':    'linear-gradient(to bottom, #c8d0dc 0%, #a8b4c4 100%)',
        'winxp-win-footer':      'linear-gradient(to bottom, #f0f0f0 0%, #e6e6e6 100%)',
      },
      boxShadow: {
        'winxp-taskbar': 'inset 0 1px 0 rgba(255,255,255,0.35)',
        'winxp-start':   'inset 0 1px 0 rgba(255,255,255,0.3), 2px 0 4px rgba(0,0,0,0.4)',
        'winxp-tray':    'inset 1px 0 0 rgba(255,255,255,0.15)',
        'winxp-window':  '0 0 0 1px rgba(80,140,210,0.8), 0 0 14px rgba(60,120,200,0.45), 0 6px 30px rgba(0,0,0,0.4)',
        'winxp-input':      'inset 1px 1px 2px rgba(0,0,0,0.2)',
        'winxp-btn':        'inset 1px 1px 0 #ffffff, inset -1px -1px 0 #acacac, 1px 1px 0 #404040',
        'winxp-btn-active': 'inset 1px 1px 2px rgba(0,0,0,0.3)',
      },
      textShadow: {
        winxp: '1px 1px 2px rgba(0,0,0,0.6)',
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
        winxp: {
          'taskbar-border':    '#0831b0',
          'start-border':      '#1a5c1a',
          'start-top':         '#7fd87f',
          'tray-border':       '#0a2880',
          'btn-control':       '#2356c9',
          'btn-control-border':  '#0831b0',
          'btn-close':         '#c42b2b',
          'btn-close-border':  '#8b1a1a',
          'window-footer':     '#cddff0',
          'win-border':        '#aaaaaa',
          'win-avatar-frame':  '#5a9e3a',
          'win-close':         '#e81123',
          'win-title':         '#003399',
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
    function({ matchUtilities, theme }) {
      matchUtilities(
        { 'text-shadow': (value) => ({ textShadow: value }) },
        { values: theme('textShadow') }
      )
    },
  ]
}
