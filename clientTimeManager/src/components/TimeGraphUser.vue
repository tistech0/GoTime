<template>
  <div>
    <div id="chart"></div>
  </div>
</template>

<script lang="ts">
import ApexCharts from 'apexcharts';
import WeekSelector from '../components/WeekSelector.vue';
import type { UserStat } from '@/types/userStat';
import {useDisplay} from 'vuetify';

interface DataProps {
  categories: Date[];
  series: any[];
  chart: any;
  options: any;
  display: any;
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
      type: Array<UserStat>,
      default: true
    }
  },
  data(props): DataProps {
    return {
      categories: this.initCategories(props.end),
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
    createSeries(data: UserStat[]) {
      let series = [];
      let day: number[] = [];
      let night: number[] = [];
      data.forEach((element) => {
        day.push(element.total_day_hours);
        night.push(element.total_night_hours);
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
      if (day.length === 0 && night.length === 0)
        series = [];
      return series;
    },
    createChart() {
      const chartElement = document.querySelector("#chart");
      if (chartElement && chartElement.hasChildNodes()) {
        chartElement.innerHTML = '';
      }
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
        plotOptions: {
          bar: {
            horizontal: false,
            borderRadius: 10,
            dataLabels: {
              total: {
                enabled: true,
                formatter: function (val: number) {
                    if (!val)
                      return '0h 0min';
                    const hours = Math.floor(val);
                    const minutes = Math.round((val - hours) * 60);
                    return `${hours}h ${minutes}min`;
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
