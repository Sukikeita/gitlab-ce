import { timeFormat as time } from 'd3-time-format';
import { bisector } from 'd3-array';

const d3 = { time, bisector };

export const dateFormat = d3.time('%b %-d, %Y');
export const timeFormat = d3.time('%-I:%M%p');
export const bisectDate = d3.bisector(d => d.time).left;
