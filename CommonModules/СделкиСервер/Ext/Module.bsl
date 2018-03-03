﻿
#Область ПрограммныйИнтерфейс

//Возвращает текущий этап процесса продажи
//
//Параметры:
//Сделка - СправочникСсылка.СделкиСКлиентами - ссылка на сделку, по которой необходимо определить текущий этап
//
// Возвращаемое значение:
//   СправочникСсылка.СостоянияПроцессов - текущий этам сделки.
//
Функция ПолучитьТекущийЭтап(Сделка) Экспорт

	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтатистикаСделокСКлиентами.ЭтапПроцесса
		|ИЗ
		|	РегистрСведений.СтатистикаСделокСКлиентами КАК СтатистикаСделокСКлиентами
		|ГДЕ
		|	СтатистикаСделокСКлиентами.Сделка = &Сделка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтатистикаСделокСКлиентами.ЭтапПроцесса.РеквизитДопУпорядочивания УБЫВ");
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Этапы = Запрос.Выполнить().Выбрать();
	Возврат ?(Этапы.Следующий(), Этапы.ЭтапПроцесса, Справочники.СостоянияПроцессов.ПустаяСсылка());

КонецФункции

// Возвращает структуру с расчетной вероятностью выигрыша сделки и ее составляющими
//
//Параметры:
//  Сделка    - СправочникСсылка.СделкиСКлиентами       - сделка, вероятность успешного завершения которой рассчитывается.
//
// Возвращаемое значение:
//   Структура - содержит следующие поля:
//    *ОбщаяСЭтапа  - Число - вероятность исходя из статистики этапа.
//    *ПоМенеджеру  - Число - вероятность исходя из статистики менеджера.
//    *ПоПартнеру   - Число - вероятность исходя из статистики по партнеру.
//    *ПоВидуСделки - Число - вероятность исходя из статистики по виду сделки.
//    *Средняя      - Число - среднее значение предыдущих параметров.
//    *Расчетная    - Число - 100 если сделка закрыта и выиграна и средняя если в работе.
//
Функция РассчитатьВероятность(Сделка) Экспорт

	// Получить необходимые реквизиты сделки
	СделкаИнф = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сделка, Новый Структура("Статус,ВероятностьУспешногоЗавершения"));

	// Получить оценку вероятности менеджером
	Если ЗначениеЗаполнено(СделкаИнф.ВероятностьУспешногоЗавершения) Тогда
		КоличествоСоставляющих = 1;
		РасчетнаяВероятность   = СделкаИнф.ВероятностьУспешногоЗавершения;
	Иначе
		КоличествоСоставляющих = 0;
		РасчетнаяВероятность   = 0;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);

	// Получить статистические вероятности
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СделкиСКлиентами.Ссылка,
		|	СделкиСКлиентами.ВидСделки,
		|	СделкиСКлиентами.Ответственный,
		|	СделкиСКлиентами.Партнер
		|ПОМЕСТИТЬ ТекущаяСделка
		|ИЗ
		|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|ГДЕ
		|	СделкиСКлиентами.Ссылка = &Сделка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтатистикаСделокСКлиентами.ЭтапПроцесса
		|ПОМЕСТИТЬ ТекущийЭтап
		|ИЗ
		|	ТекущаяСделка КАК ТекущаяСделка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатистикаСделокСКлиентами КАК СтатистикаСделокСКлиентами
		|		ПО ТекущаяСделка.Ссылка = СтатистикаСделокСКлиентами.Сделка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтатистикаСделокСКлиентами.ЭтапПроцесса.РеквизитДопУпорядочивания УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(СтатистикаСделокСКлиентами.Сделка) КАК Количество
		|ПОМЕСТИТЬ ВыигранныеСЭтапа
		|ИЗ
		|	ТекущийЭтап КАК ТекущийЭтап
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатистикаСделокСКлиентами КАК СтатистикаСделокСКлиентами
		|		ПО ТекущийЭтап.ЭтапПроцесса = СтатистикаСделокСКлиентами.ЭтапПроцесса
		|ГДЕ
		|	СтатистикаСделокСКлиентами.Сделка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.Выиграна)
		|	И (НЕ СтатистикаСделокСКлиентами.Сделка.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(СтатистикаСделокСКлиентами.Сделка) КАК Количество
		|ПОМЕСТИТЬ ОпределенныеСЭтапа
		|ИЗ
		|	ТекущийЭтап КАК ТекущийЭтап
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатистикаСделокСКлиентами КАК СтатистикаСделокСКлиентами
		|		ПО ТекущийЭтап.ЭтапПроцесса = СтатистикаСделокСКлиентами.ЭтапПроцесса
		|ГДЕ
		|	СтатистикаСделокСКлиентами.Сделка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.ВРаботе)
		|	И (НЕ СтатистикаСделокСКлиентами.Сделка.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ПОМЕСТИТЬ ВыигранныеПоМенеджеру
		|ИЗ
		|	ТекущаяСделка КАК ТекущаяСделка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО ТекущаяСделка.Ответственный = СделкиСКлиентами.Ответственный
		|ГДЕ
		|	СделкиСКлиентами.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.Выиграна)
		|	И (НЕ СделкиСКлиентами.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ПОМЕСТИТЬ ОпределенныеПоМенеджеру
		|ИЗ
		|	ТекущаяСделка КАК ТекущаяСделка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО ТекущаяСделка.Ответственный = СделкиСКлиентами.Ответственный
		|ГДЕ
		|	СделкиСКлиентами.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.ВРаботе)
		|	И (НЕ СделкиСКлиентами.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ПОМЕСТИТЬ ВыигранныеПоВиду
		|ИЗ
		|	ТекущаяСделка КАК ТекущаяСделка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО ТекущаяСделка.ВидСделки = СделкиСКлиентами.ВидСделки
		|ГДЕ
		|	СделкиСКлиентами.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.Выиграна)
		|	И (НЕ СделкиСКлиентами.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ПОМЕСТИТЬ ОпределенныеПоВиду
		|ИЗ
		|	ТекущаяСделка КАК ТекущаяСделка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО ТекущаяСделка.ВидСделки = СделкиСКлиентами.ВидСделки
		|ГДЕ
		|	СделкиСКлиентами.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.ВРаботе)
		|	И (НЕ СделкиСКлиентами.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ПОМЕСТИТЬ ВыигранныеПоПартнеру
		|ИЗ
		|	ТекущаяСделка КАК ТекущаяСделка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО ТекущаяСделка.Партнер = СделкиСКлиентами.Партнер
		|ГДЕ
		|	СделкиСКлиентами.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.Выиграна)
		|	И (НЕ СделкиСКлиентами.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ПОМЕСТИТЬ ОпределенныеПоПартнеру
		|ИЗ
		|	ТекущаяСделка КАК ТекущаяСделка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО ТекущаяСделка.Партнер = СделкиСКлиентами.Партнер
		|ГДЕ
		|	СделкиСКлиентами.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.ВРаботе)
		|	И (НЕ СделкиСКлиентами.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ОпределенныеСЭтапа.Количество, 1) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ВыигранныеСЭтапа.Количество, 0) / ЕСТЬNULL(ОпределенныеСЭтапа.Количество, 1) * 100
		|	КОНЕЦ КАК ПоЭтапу,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ОпределенныеПоМенеджеру.Количество, 1) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ВыигранныеПоМенеджеру.Количество, 0) / ЕСТЬNULL(ОпределенныеПоМенеджеру.Количество, 1) * 100
		|	КОНЕЦ КАК ПоМенеджеру,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ОпределенныеПоВиду.Количество, 1) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ВыигранныеПоВиду.Количество, 0) / ЕСТЬNULL(ОпределенныеПоВиду.Количество, 1) * 100
		|	КОНЕЦ КАК ПоВидуСделки,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ОпределенныеПоПартнеру.Количество, 1) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ВыигранныеПоПартнеру.Количество, 0) / ЕСТЬNULL(ОпределенныеПоПартнеру.Количество, 1) * 100
		|	КОНЕЦ КАК ПоПартнеру
		|ИЗ
		|	ВыигранныеПоВиду КАК ВыигранныеПоВиду,
		|	ВыигранныеПоМенеджеру КАК ВыигранныеПоМенеджеру,
		|	ВыигранныеПоПартнеру КАК ВыигранныеПоПартнеру,
		|	ВыигранныеСЭтапа КАК ВыигранныеСЭтапа,
		|	ОпределенныеПоВиду КАК ОпределенныеПоВиду,
		|	ОпределенныеПоМенеджеру КАК ОпределенныеПоМенеджеру,
		|	ОпределенныеПоПартнеру КАК ОпределенныеПоПартнеру,
		|	ОпределенныеСЭтапа КАК ОпределенныеСЭтапа");
	Запрос.УстановитьПараметр("Сделка",Сделка);
	Выборка = Запрос.Выполнить().Выбрать();

	// Начальные значения
	Результат = Новый Структура("ОбщаяСЭтапа,ПоМенеджеру,ПоПартнеру,ПоВидуСделки,Средняя,Расчетная");

	//заполнить результат статистическими данными
	Если Выборка.Следующий() Тогда
		Если Выборка.ПоЭтапу > 0 Тогда
			Результат.ОбщаяСЭтапа  = Окр(Выборка.ПоЭтапу,2);
			РасчетнаяВероятность   = РасчетнаяВероятность + Результат.ОбщаяСЭтапа; 
			КоличествоСоставляющих = КоличествоСоставляющих + 1;
		КонецЕсли;
		Если Выборка.ПоМенеджеру > 0 Тогда
			Результат.ПоМенеджеру  = Окр(Выборка.ПоМенеджеру,2);
			РасчетнаяВероятность   = РасчетнаяВероятность + Результат.ПоМенеджеру; 
			КоличествоСоставляющих = КоличествоСоставляющих + 1;
		КонецЕсли;
		Если Выборка.ПоПартнеру > 0 Тогда
			Результат.ПоПартнеру   = Окр(Выборка.ПоПартнеру,2);
			РасчетнаяВероятность   = РасчетнаяВероятность + Результат.ПоПартнеру; 
			КоличествоСоставляющих = КоличествоСоставляющих + 1;
		КонецЕсли;
		Если Выборка.ПоВидуСделки > 0 Тогда
			Результат.ПоВидуСделки = Окр(Выборка.ПоВидуСделки,2);
			РасчетнаяВероятность   = РасчетнаяВероятность + Результат.ПоВидуСделки;
			КоличествоСоставляющих = КоличествоСоставляющих + 1;
		КонецЕсли;
	КонецЕсли;

	//заполнить результат расчетными данными
	Если КоличествоСоставляющих > 0 Тогда
		Результат.Средняя = РасчетнаяВероятность/КоличествоСоставляющих;
	КонецЕсли;
	
	Если СделкаИнф.Статус = Перечисления.СтатусыСделок.Проиграна Тогда
		Результат.Расчетная = 0;
	ИначеЕсли Сделка.Закрыта Тогда
		Результат.Расчетная = 100;
	Иначе
		Результат.Расчетная = Результат.Средняя;
	КонецЕсли;

	Возврат Результат;

КонецФункции

//Устанавливает этап процесса продажи для сделки.
//Параметры:
//  Сделка - СправочникСсылка.СделкиСКлиентами   - ссылка на сделку, по которой производится переход.
//  Этап   - СправочникСсылка.СостояниеПроцессов - этап, на который нужно перевести сделку.
//
Процедура УстановитьЭтапПроцесса(Сделка, Этап) Экспорт

	//найти текущий этап по сделке
	ТекущийЭтап = ПолучитьТекущийЭтап(Сделка);

	//заполнить статистику
	Если ТекущийЭтап = Справочники.СостоянияПроцессов.ПустаяСсылка() Тогда
		
		//первая запись по сделке
		Запись = ПолучитьЗаписьСтатистики(Сделка, Этап);
		Запись.Записать();
	Иначе
		
		//получить информацию о сделке
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	СделкиСКлиентами.ВидСделки,
			|	СделкиСКлиентами.ВидСделки.ТипСделки КАК ТипСделки,
			|	СделкиСКлиентами.Статус,
			|	СделкиСКлиентами.ПереведенаНаУправлениеВРучную
			|ИЗ
			|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
			|ГДЕ
			|	СделкиСКлиентами.Ссылка = &Сделка");
		Запрос.УстановитьПараметр("Сделка", Сделка);
		ИнфСделки = Запрос.Выполнить().Выбрать();
		ИнфСделки.Следующий();
		
		Если ИнфСделки.ТипСделки = Перечисления.ТипыСделокСКлиентами.СделкиСРучнымПереходомПоЭтапам
			ИЛИ ИнфСделки.ПереведенаНаУправлениеВРучную Тогда
			//сделки с управлением процессом "в ручную"
			
			//получить этапы по виду сделки
			Запрос = Новый Запрос(
				"ВЫБРАТЬ
				|	ВидыСделокСКлиентамиЭтапыСделкиПоПродаже.ЭтапПроцессаПродажи
				|ИЗ
				|	Справочник.ВидыСделокСКлиентами.ЭтапыСделкиПоПродаже КАК ВидыСделокСКлиентамиЭтапыСделкиПоПродаже
				|ГДЕ
				|	ВидыСделокСКлиентамиЭтапыСделкиПоПродаже.Ссылка = &ВидСделки
				|
				|УПОРЯДОЧИТЬ ПО
				|	ВидыСделокСКлиентамиЭтапыСделкиПоПродаже.НомерСтроки");
			Запрос.УстановитьПараметр("ВидСделки", ИнфСделки.ВидСделки);
			Этапы = Запрос.Выполнить().Выгрузить();

			//определить направление движения
			ИндексТекущегоЭтапа = Этапы.Индекс(Этапы.Найти(ТекущийЭтап, "ЭтапПроцессаПродажи"));
			ИндексЭтапа         = Этапы.Индекс(Этапы.Найти(Этап, "ЭтапПроцессаПродажи"));
			Если ИндексЭтапа > ИндексТекущегоЭтапа Тогда
				//переход на следующий этап
				ЗакрытьСтатистику(Сделка, ТекущийЭтап);
				Для СчетчикЭтапов = ИндексТекущегоЭтапа + 1 По ИндексЭтапа Цикл
					ДобавляемыйЭтап = Этапы[СчетчикЭтапов].ЭтапПроцессаПродажи;
					Запись = ПолучитьЗаписьСтатистики(Сделка, ДобавляемыйЭтап);
					Если СчетчикЭтапов < ИндексЭтапа Тогда
						Запись.ДатаОкончания = Запись.ДатаНачала;
						Запись.Результат     = Перечисления.СтатусыСделок.Выиграна;
					КонецЕсли;
					Запись.Записать();
				КонецЦикла;
			Иначе
				//возврат на предыдущий этап

				//скорректировать статистику
				//удалить отменяемые этапы
				Выборка = РегистрыСведений.СтатистикаСделокСКлиентами.Выбрать(Новый Структура("Сделка",Сделка));
				Пока Выборка.Следующий() Цикл
					ТекущийИндекс = Этапы.Индекс(Этапы.Найти(Выборка.ЭтапПроцесса, "ЭтапПроцессаПродажи"));
					Если ТекущийИндекс <= ИндексТекущегоЭтапа И ТекущийИндекс > ИндексЭтапа Тогда
						Запись = Выборка.ПолучитьМенеджерЗаписи();
						Запись.Удалить();
					КонецЕсли;
				КонецЦикла;
				
				//сбросить закрытие текущего этапа
				Запись = ПолучитьЗаписьСтатистики(Сделка, Этап);
				Запись.Ответственный     = Пользователи.ТекущийПользователь();
				Запись.ДатаОкончания     = Неопределено;
				Запись.Продолжительность = Неопределено;
				Запись.Результат         = ?(
					ИнфСделки.Статус = Перечисления.СтатусыСделок.Проиграна,
					Перечисления.СтатусыСделок.Проиграна, Перечисления.СтатусыСделок.ВРаботе);
				Запись.Записать();
			КонецЕсли;
		Иначе
			//сделки с управлением бизнес-процессом
			
			ЗакрытьСтатистику(Сделка, ТекущийЭтап);
			Запись = ПолучитьЗаписьСтатистики(Сделка, Этап);
			Запись.Записать();
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

//Найти или создать запись статистики сделок
//Параметры:
//  Сделка    - СправочникСсылка.СделкиСКлиентами   - сделка, по которой создается запись.
//  Состояние - СправочникСсылка.СостоянияПроцессов - этап процесса продажи.
//
// Возвращаемое значение:
//   РегистрСведенийМенеджерЗаписи.СтатистикаСделокСКлиентами - найденная или созданная запись.
//
Функция ПолучитьЗаписьСтатистики(Сделка, Этап) Экспорт

	Запись = РегистрыСведений.СтатистикаСделокСКлиентами.СоздатьМенеджерЗаписи();
	Запись.Сделка       = Сделка;
	Запись.ЭтапПроцесса = Этап;
	Запись.Прочитать();
	Если НЕ Запись.Выбран() Тогда
		Запись.Сделка        = Сделка;
		Запись.Результат     = Перечисления.СтатусыСделок.ВРаботе;
		Запись.Потенциал     = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сделка, "ПотенциальнаяСуммаПродажи");
		Запись.ДатаНачала    = ТекущаяДатаСеанса();
		Запись.ЭтапПроцесса  = Этап;
		Запись.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;

	Возврат Запись;

КонецФункции

//Записать завершение этапа в статистику
//Параметры:
//  Сделка          - СправочникСсылка.СделкиСКлиентами - сделка, по которой создается запись.
//  Этап            - СправочникСсылка.СостоянияПроцессов - закрываемый этап процесса продажи.
//  ОтменаПроигрыша - Булево - признак, того что выполняется отмена проигрыша сделки.
//
Процедура ЗакрытьСтатистику(Сделка, Этап, ОтменаПроигрыша = Ложь) Экспорт

	Запись = ПолучитьЗаписьСтатистики(Сделка, Этап);
	Запись.ДатаОкончания     = ТекущаяДатаСеанса();
	Запись.Потенциал         = Сделка.ПотенциальнаяСуммаПродажи;
	Запись.Продолжительность = Продолжительность(Запись.ДатаНачала, Запись.ДатаОкончания);
	Запись.Результат         = ?(
		Запись.Результат = Перечисления.СтатусыСделок.ВРаботе ИЛИ ОтменаПроигрыша,
		Перечисления.СтатусыСделок.Выиграна,
		Запись.Результат);
	Запись.Записать();

КонецПроцедуры

//Заполняет реквизиты задач процесса продажи при их создании.
//
//Параметры:
//  Сделка                      - СправочникСсылка.СделкиСКлиентами - сделка, которой по которой создан процесс.
//  Процесс                     - БизнесПроцесс.ТиповаяПродажа - бизнес процесс продажи.
//  ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута, по которой создаются задачи.
//  ФормируемыеЗадачи           - Массив - массив формируемых задач.
//
Процедура ЗаполнитьРеквизитыЗадачПроцесса(Сделка, Процесс, ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи) Экспорт

	//сформировать название задач
	НаименованиеЗадачи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='%1 по сделке %2'"),
		ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи,
		Сделка);

	ОтветственныйПоСделке = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сделка,"Ответственный");
	
	//заполнить реквизиты
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Задача.Наименование         = НаименованиеЗадачи;
		Задача.Важность             = Перечисления.ВариантыВажностиЗадачи.Обычная;
		Задача.Описание             = Процесс.ОписаниеТочки(ТочкаМаршрутаБизнесПроцесса);
		Задача.СрокИсполнения       = ТекущаяДатаСеанса() + Процесс.СрокИсполнения(ТочкаМаршрутаБизнесПроцесса)*86400;
		Задача.Автор                = ОтветственныйПоСделке;
		Задача.Исполнитель          = ОтветственныйПоСделке;
		Задача.Предмет              = Сделка;
	КонецЦикла;

КонецПроцедуры

//Формирует и запускает экземпляр бизнес-процесса по сделке
//Параметры:
//  Сделка - СправочникСсылка.СделкиСКлиентами - сделка, которой по которой создается процесс.
//
Процедура ЗапуститьПроцесс(Знач Сделка) Экспорт
	
	//получить необходимые реквизиты сделки
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СделкиСКлиентами.Наименование,
		|	СделкиСКлиентами.Ответственный,
		|	СделкиСКлиентами.ВидСделки.ТипСделки КАК ТипСделки
		|ИЗ
		|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|ГДЕ
		|	СделкиСКлиентами.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Сделка);
	СделкаИнф = Запрос.Выполнить().Выбрать();
	СделкаИнф.Следующий();

	//определить количество активных процессов по сделке
	ИмяПроцесса = ПолучитьОписаниеТипаСделки(СделкаИнф.ТипСделки).Имя;
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК КоличествоПроцессов
		|ИЗ
		|	БизнесПроцесс." + ИмяПроцесса + " КАК ПроцессПродажи
		|ГДЕ
		|	ПроцессПродажи.Стартован
		|	И НЕ ПроцессПродажи.Завершен
		|	И ПроцессПродажи.Предмет = &Сделка");
	Запрос.УстановитьПараметр("Сделка", Сделка);

	//запустить бизнес-процесс продажи, если не запущен
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Если Выборка.КоличествоПроцессов = 0 Тогда
		
		НачатьТранзакцию();
		
		Попытка
			
			Процесс = БизнесПроцессы[ИмяПроцесса].СоздатьБизнесПроцесс();
			Процесс.Дата         = ТекущаяДатаСеанса();
			Процесс.Предмет      = Сделка;
			Процесс.Автор        = СделкаИнф.Ответственный;
			Процесс.Наименование = СделкаИнф.Наименование;
			Процесс.Записать();
			Процесс.Старт();
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОтменитьТранзакцию();
		КонецПопытки;
	КонецЕсли;

КонецПроцедуры

//Отменяет (проставляет пометки удаления) текущие задачи и перезапускает бизнес-процесс
//Параметры:
//  Сделка    - СправочникСсылка.СделкиСКлиентами - сделка, процесс которой нужно стартовать заново.
//  ТипСделки - ПеречислениеСсылка.ТипыСделокСКлиентами - тип сделки, определяет метаданные процесса.
//
Процедура ПерезапуститьПроцессПродажи(Сделка, ТипСделки) Экспорт

	//найти экземпляры процессов сделки
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПроцессПродажи.Ссылка
		|ИЗ
		|	БизнесПроцесс." + ПолучитьОписаниеТипаСделки(ТипСделки).Имя + " КАК ПроцессПродажи
		|ГДЕ
		|	ПроцессПродажи.Стартован
		|	И НЕ ПроцессПродажи.Завершен
		|	И ПроцессПродажи.Предмет = &Сделка");
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Процессы = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	Попытка
		
		Пока Процессы.Следующий() Цикл
			ОтменитьЗадачиПроцесса(Процессы.Ссылка);
			ПроцессОбъект = Процессы.Ссылка.ПолучитьОбъект();
			ПроцессОбъект.Стартован = Ложь;
			ПроцессОбъект.Старт();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОтменитьТранзакцию();
	КонецПопытки;

КонецПроцедуры

//Отменяет текущие задачи и завершает бизнес-процесс сделки
//
//Параметры:
//  Сделка    - СправочникСсылка.СделкиСКлиентами       - сделка, процесс которой нужно завершить.
//  ТипСделки - ПеречислениеСсылка.ТипыСделокСКлиентами - тип сделки, определяет метаданные процесса.
//
Процедура ЗавершитьПроцессПродажи(Сделка, ТипСделки) Экспорт

	//найти экземпляры процессов сделки
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПроцессПродажи.Ссылка
		|ИЗ
		|	БизнесПроцесс." + ПолучитьОписаниеТипаСделки(ТипСделки).Имя + " КАК ПроцессПродажи
		|ГДЕ
		|	ПроцессПродажи.Стартован
		|	И НЕ ПроцессПродажи.Завершен
		|	И ПроцессПродажи.Предмет = &Сделка");
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Процессы = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	Попытка
		Пока Процессы.Следующий() Цикл
			ЗавершитьБизнесПроцесс(Процессы.Ссылка);
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОтменитьТранзакцию();
	КонецПопытки;

КонецПроцедуры

// По ссылке на перечисление ТипыСделокСКлиентами получить имя и представление.
//
//Параметры:
//  ТипСделки - ПеречислениеСсылка.ТипыСделокСКлиентами - тип сделки, определяет метаданные процесса.
//
// Возвращаемое значение:
//   Структура - имеет следующие поля:
//    * Имя - Строка - имя значения перечисления.
//    * Представление - Строка - представление значения перечисления.
//
Функция ПолучитьОписаниеТипаСделки(ТипСделки) Экспорт

	Для Каждого Элемент Из Метаданные.Перечисления.ТипыСделокСКлиентами.ЗначенияПеречисления Цикл
		Если Перечисления.ТипыСделокСКлиентами[Элемент.Имя] = ТипСделки Тогда
			Результат = Новый Структура;
			Результат.Вставить("Имя", Элемент.Имя);
			Результат.Вставить(
				"Представление",
				?(ПустаяСтрока(Элемент.Синоним), Элемент.Имя, Элемент.Синоним));

			Возврат Результат;

		КонецЕсли;
	КонецЦикла;

	Возврат Новый Структура("Имя,Представление", "", "");

КонецФункции

//Возвращает в отчет "воронка продаж" значение порядка результата прохождения этапа.
//
// Параметры:
//  Результат - ПеречислениеСсылка.СтатусыСделок -текущий статус сделки.
//
// Возвращаемое значение:
//   Число - значение упорядочивания статуса сделки в отчете.
//
Функция ПолучитьПорядокРезультата(Результат) Экспорт

	Если Результат = Перечисления.СтатусыСделок.Выиграна Тогда
		Возврат 1;
	ИначеЕсли Результат = Перечисления.СтатусыСделок.ВРаботе Тогда
		Возврат 2;
	Иначе
		Возврат 3;
	КонецЕсли;

КонецФункции

// Получает участников взаимодействия по табличной части предмета взаимодействия
//
// Параметры:
//  Ссылка            - СправочникСсылка - предмет взаимодействия
//  ОсновнойУчастник    СправочникСсылка - участник взаимодействия, которого должен попасть в результирующий
//   массив, вне зависимости, содержится ли он в табличной части предмета взаимодействия или нет.
//
// Возвращаемое значение:
//   Массив             - массив участников взаимодействия.
//
Функция ПолучитьУчастниковПоТабличнойЧастиПредметаВзаимодействия(Ссылка, ОсновнойУчастник = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПолноеИмя = Ссылка.Метаданные().ПолноеИмя();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПартнерыИКонтактныеЛица.Партнер КАК Владелец,
	|	ПартнерыИКонтактныеЛица.КонтактноеЛицо КАК Подчиненный
	|ИЗ
	|	" + ПолноеИмя + ".ПартнерыИКонтактныеЛица КАК ПартнерыИКонтактныеЛица
	|ГДЕ
	|	ПартнерыИКонтактныеЛица.Ссылка = &Ссылка";
	
	Результат = Новый Массив;
	Если ЗначениеЗаполнено(ОсновнойУчастник) Тогда
		Результат.Добавить(ОсновнойУчастник);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Контакт = ?(ЗначениеЗаполнено(Выборка.Подчиненный), Выборка.Подчиненный, Выборка.Владелец);
		Если Контакт <> ОсновнойУчастник Тогда
			Результат.Добавить(Контакт);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Завершает процессы заданий по задаче и устанавливает пометку удаления
//Параметры:
//Задача - ссылка на отменяемую задачу
//
Процедура ОтменитьЗадачу(Задача)

	ЗадачаОбъект = Задача.ПолучитьОбъект();
	ЗадачаОбъект.ПометкаУдаления = Истина;
	ЗадачаОбъект.Записать();

КонецПроцедуры

//Отменяет (проставляет пометки удаления) текущие задачи и завершает процесс
//Параметры:
//Процесс - ссылка на завершаемый процесс
//
Процедура ЗавершитьБизнесПроцесс(Процесс)

	ОтменитьЗадачиПроцесса(Процесс);
	ПроцессОбъект = Процесс.ПолучитьОбъект();
	ПроцессОбъект.Завершен = Истина;
	ПроцессОбъект.Записать();

КонецПроцедуры

//Отменяет (проставляет пометки удаления) текущие задачи процесса
Процедура ОтменитьЗадачиПроцесса(Процесс)

	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
		|	И (НЕ ЗадачаИсполнителя.Выполнена)");
	Запрос.УстановитьПараметр("БизнесПроцесс", Процесс);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОтменитьЗадачу(Выборка.Ссылка);
	КонецЦикла;

КонецПроцедуры

//Рассчитать продолжительность пребывания на стадии в днях
Функция Продолжительность(Старт, Финиш)
	
	Возврат Окр((Финиш - Старт)/84600,0);

КонецФункции

#КонецОбласти
