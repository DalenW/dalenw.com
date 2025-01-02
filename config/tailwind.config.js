const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['font', ...defaultTheme.fontFamily.sans],
      },
       colors: {
        gruvboxDark: {
          bg: "#282828",
          bg0: "#282828",
          bgH: "#1d2021",
          bgS: "#32302f",
          bg1: "#3c3836",
          bg2: "#504945",
          bg3: "#665c54",
          bg4: "#7c6f64",

          fg: "#ebdbb2",
          fg0: "#fbf1c7",
          fg1: "#ebdbb2",
          fg2: "#d5c4a1",
          fg3: "#bdae93",
          fg4: "#a89984",

          red: "#cc241d",
          red2: "#fb4934",
          green: "#98971a",
          green2: "#b8bb26",
          yellow: "#d79921",
          yellow2: "#fabd2f",
          blue: "#458588",
          blue2: "#83a598",
          purple: "#b16286",
          purple2: "#d3869b",
          aqua: "#689d6a",
          aqua2: "#8ec07c",
          orange: "#d65d0e",
          orange2: "#fe8019",
          gray: "#a89984",
          gray2: "#928374"
        },
        gruvbox: {
          bg: "#fbf1c7",
          bg0: "#fbf1c7",
          bgH: "#f9f5d7",
          bgS: "#f2e5bc",
          bg1: "#ebdbb2",
          bg2: "#d5c4a1",
          bg3: "#bdae93",
          bg4: "#a89984",

          fg: "#3c3836",
          fg0: "#282828",
          fg1: "#3c3836",
          fg2: "#504945",
          fg3: "#665c54",
          fg4: "#7c6f64",

          red: "#cc241d",
          red2: "#9d0006",
          green: "#98971a",
          green2: "#79740e",
          yellow: "#d79921",
          yellow2: "#b57614",
          blue: "#458588",
          blue2: "#076678",
          purple: "#b16286",
          purple2: "#8f3f71",
          aqua: "#689d6a",
          aqua2: "#427b58",
          orange: "#d65d0e",
          orange2: "#af3a03",
          gray: "#7c6f64",
          gray2: "#928374"
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('daisyui')
  ],
  daisyui: {
    themes: [
      {
        /* https://daisyui.com/theme-generator/ */
        gruvboxDark: {
          "primary": "#fe8019",
          "primary-content": "#282828",
          "secondary": "#d65d0e",
          "secondary-content": "#282828",
          "accent": "#282828",
          "accent-content": "#fbf1c7",
          "neutral": "#d5c4a1",
          "neutral-content": "#282828",
          "base-100": "#3c3836",
          "base-200": "#504945",
          "base-300": "#665c54",
          "base-content": "#fbf1c7",
          "info": "#458588",
          "info-content": "#282828",
          "success": "#b8bb26",
          "success-content": "#282828",
          "warning": "#fabd2f",
          "warning-content": "#282828",
          "error": "#fb4934",
          "error-content": "#282828",

          "--rounded-box": "0", // border radius rounded-box utility class, used in card and other large boxes
          "--rounded-btn": "0", // border radius rounded-btn utility class, used in buttons and similar element
          "--rounded-badge": "0", // border radius rounded-badge utility class, used in badges and similar
          "--animation-btn": "0.25s", // duration of animation when you click on button
          "--animation-input": "0.2s", // duration of animation for inputs like checkbox, toggle, radio, etc
          "--btn-focus-scale": "0.95", // scale transform of button when you focus on it
          "--border-btn": "1px", // border width of buttons
          "--tab-border": "1px", // border width of tabs
          "--tab-radius": "0", // border radius of tabs
        },
      },
    ],
  },
}
