<template>
  <div>
    <div id="chart"></div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, ref, toRefs, onMounted, computed } from 'vue';
import ApexCharts from 'apexcharts';
import WeekSelector from "@/components/WeekSelector.vue";
import { useDisplay } from 'vuetify';

export default defineComponent({
  components: {WeekSelector},
  props: {
    start: {
      type: Date,
      default: true,
    },
    end: {
      type: Date,
      default: true,
    },
  },
  setup(props) {
    const { start, end } = toRefs(props);

    let categories: Date[] = [];

    function initCategories(start: Date, end: Date): void {
      let currentDate = new Date(end);
      const newCategories = [];

      for (let i = 0; i < 7; i++) {
        newCategories.push(new Date(currentDate));
        currentDate.setDate(currentDate.getDate() + 1);
      }
      categories = newCategories;
    }

    initCategories(start.value, end.value);

    let data = [
      {
        "id": 1,
        "start": "2023-10-25T20:48:13",
        "end": "2023-10-25T20:48:37",
        "valueDay": 3,
        "valueNight": 2,
      },
      {
        "id": 2,
        "start": "2023-11-25T09:23:45",
        "end": "2023-11-25T18:30:31",
        "valueDay": 4,
        "valueNight": 3,
      },
      {
        "id": 3,
        "start": "2023-12-25T10:21:25",
        "end": "2023-12-25T17:49:56",
        "valueDay": 3,
        "valueNight": 8,
      },
      {
        "id": 4,
        "start": "2023-12-25T10:21:25",
        "end": "2023-12-25T17:49:56",
        "valueDay": 6,
        "valueNight": 2,
      },
      {
        "id": 5,
        "start": "2023-12-25T10:21:25",
        "end": "2023-12-25T17:49:56",
        "valueDay": 6,
        "valueNight": 2,
      },
    ]

    let min = [1, 2, 3, 2, 4, 0, 0];
    let max = [6, 7, 8, 4, 7, 0, 0];
    let series = createSeries(data);

    const display = useDisplay();
    function createSeries(data: any) {
      let series = [];
      let day: any = [];
      let night: any = [];

      data.forEach((element: any) => {
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
    }

    const chart = ref<ApexCharts | null>(null);

    const options = {
      series: series,
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
              formatter: function (val: number, opts: any) {
                return display.mobile.value ? '' : "Mini:" + min[opts.dataPointIndex] + "h "+ "Max:" + max[opts.dataPointIndex] + "h";
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
        categories: categories,
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

    onMounted(() => {
      chart.value = new ApexCharts(document.querySelector('#chart')!, options);
      chart.value.render();
    });

    return {
      categories,
      max,
      min,
      series

    };
  },
});
</script>
