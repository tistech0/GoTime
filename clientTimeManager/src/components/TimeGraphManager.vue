<template>
  <div>
    <div id="chart"></div>
  </div>
</template>

<script lang="ts">
import ApexCharts from 'apexcharts';
import WeekSelector from '../components/WeekSelector.vue';
import type { TableStats } from '@/types/tableStats';
import {useDisplay} from 'vuetify';

interface DataProps {
  categories: Date[];
  min: number[];
  max: number[];
  series: any[];
  chart: any;
  options: any;
  display: DisplayInstance;
}

export default {
  components: { WeekSelector },
  props: {
    start: {
      type: Date,
      default: true,
    },
    end: {
      type: Date,
      default: true,
    },
    workingTimeList: {
      type: Array<TableStats>,
      default: true
    }
  },
  data(props): DataProps {
    return {
      categories: this.initCategories(props.end),
      min: [1, 2, 3, 2, 4, 0, 0],
      max: [6, 7, 8, 4, 7, 0, 0],
      series: [],
      chart: ApexCharts,
      options: {},
      display: useDisplay()
    };
  },
  methods: {
    initCategories(end: Date): Date[] {
      let currentDate = new Date(end);

      const newCategories = [];
      for (let i = 0; i < 7; i++) {
        newCategories.push(new Date(currentDate));
        currentDate.setDate(currentDate.getDate() + 1);
      }
      return newCategories;
    },
    createSeries(data: TableStats[]) {
      let series = [];
      let day: number[] = [];
      let night: number[] = [];
      console.log(data);
      data.forEach((element) => {
        day.push(element.valueDay);
        night.push(element.valueNight);
      });

      series.push({
        name: "Day average time",
        data: day,
        color: "#48A9A6",
      });

      series.push({
        name: "Nigth average time",
        data: night,
        color: "#1B2A41",
      });

      return series;
    },
    createChart() {
      this.chart = new ApexCharts(document.querySelector('#chart'), this.options);
      this.chart.render();
    },
    updateChart() {
      this.series = this.createSeries(this.workingTimeList);
      this.options = {
        series: this.series,
        chart: {
          toolbar: {
            show: true,
            tools: {
              download: true,
              selection: false,
              zoom: false,
              zoomin: false,
              zoomout: false,
              pan: false,
              reset: false,
            },
          },
          type: 'bar',
          height: 350,
          stacked: true,
        },
        responsive: [
          {
            breakpoint: 480,
            options: {
              legend: {
                position: 'bottom',
                offsetX: -10,
                offsetY: 0,
              },
            },
          },
        ],
        dataLabel: {
          enabled: true,
        },
        plotOptions: {
          bar: {
            horizontal: false,
            borderRadius: 10,
            dataLabels: {
              total: {
                enabled: true,
                formatter: (val: number, opts: any): string => {
                  return this.display.mobile.value ? '' : "Mini:" + this.min[opts.dataPointIndex] + "h "+ "Max:" + this.max[opts.dataPointIndex] + "h";
                },
                style: {
                  fontSize: '13px',
                  fontWeight: 900,
                },
              },
            },
          },
        },
        xaxis: {
          type: 'category',
          categories: this.categories,
          labels: {
            formatter: function (val: Date) {
              return val.toLocaleDateString('en-US', { weekday: 'short', day: '2-digit', month: 'short' });
            },
          },
        },
        legend: {
          position: 'right',
          offsetY: 40,
        },
        fill: {
          opacity: 1,
        },
        grid: {
          borderColor: '#f1f1f1',
        },
      };
      if (this.workingTimeList.length > 0)
        this.createChart();
    }
  },
  mounted() {
    this.updateChart();
  },
  watch: {
    workingTimeList: {
      handler() {
        this.updateChart();
      },
      deep: true
    }
  }
};

</script>
