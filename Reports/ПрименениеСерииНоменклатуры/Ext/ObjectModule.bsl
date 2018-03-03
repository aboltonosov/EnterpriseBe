﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.Вставить("РазрешеноМенятьВарианты", Ложь);
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	ЭтаФорма.РежимВариантаОтчета = Ложь;

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		ЗначениеПоиска = Новый ПараметрКомпоновкиДанных("Номенклатура");
		Для каждого ЭлементПараметр Из КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.Элементы Цикл
			Если ЭлементПараметр.Параметр = ЗначениеПоиска Тогда
				ЭлементПараметр.ПредставлениеПользовательскойНастройки = НСтр("ru = 'Комплектующая'");
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИспользоватьПроизводство = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ОтборНоменклатура = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение;
	ОтборСерия = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Серия").Значение;
	
	Если НЕ ЗначениеЗаполнено(ОтборНоменклатура) Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Полуфабрикат или материал"" не заполнено.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Поле ""Комплектующая"" не заполнено.'");
		КонецЕсли; 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ОтборСерия) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Серия"" не заполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	#Область Инициализация
	ИспользоватьПроизводство = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Номенклатура", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение);
	ПараметрыОтчета.Вставить("Характеристика", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Характеристика").Значение);
	ПараметрыОтчета.Вставить("Серия", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Серия").Значение);
	
	СтруктураСерииДерево = ПрименениеСерииНоменклатуры(ПараметрыОтчета);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ПрименениеСерииНоменклатуры.ПФ_MXL_ПрименениеСерииНоменклатуры");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПараметры = Макет.ПолучитьОбласть("Параметры");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	#КонецОбласти
	
	// Вывод области Заголовок
	#Область ОбластьЗаголовок
	ПараметрыОбласти = Новый Структура("ТекстЗаголовка", НСтр("ru = 'Применение серии номенклатуры'"));
	ОбластьЗаголовок.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.Вывести(ОбластьЗаголовок);
	#КонецОбласти
	
	// Вывод области Параметры
	#Область ОбластьПараметры
	ПараметрыОбласти = Новый Структура;
	ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
										Строка(ПараметрыОтчета.Номенклатура), 
										Строка(ПараметрыОтчета.Характеристика));
										
	ПараметрыОбласти.Вставить("ОтборНоменклатура", ПредставлениеНоменклатуры);
	ПараметрыОбласти.Вставить("ОтборСерия", Строка(ПараметрыОтчета.Серия));
	Если ИспользоватьПроизводство Тогда
		ПараметрыОбласти.Вставить("ТекстМатериал", НСтр("ru = 'Полуфабрикат или материал'"));
	Иначе
		ПараметрыОбласти.Вставить("ТекстМатериал", НСтр("ru = 'Комплектующая'"));
	КонецЕсли;
	ОбластьПараметры.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	ДокументРезультат.Вывести(ОбластьПустаяСтрока, 1,, Истина);
	ДокументРезультат.Вывести(ОбластьПараметры, 2,, Истина);
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
	ДокументРезультат.Вывести(ОбластьПустаяСтрока);
	#КонецОбласти

	// Вывод области Шапка
	#Область ОбластьШапка
	ПараметрыОбласти = Новый Структура;
	Если ИспользоватьПроизводство Тогда
		ПараметрыОбласти.Вставить("ТекстПродукция", НСтр("ru = 'Продукция или полуфабрикат'"));
		ПараметрыОбласти.Вставить("ТекстПроизведено", НСтр("ru = 'Произведено'"));
	Иначе
		ПараметрыОбласти.Вставить("ТекстПродукция", НСтр("ru = 'Комплект'"));
		ПараметрыОбласти.Вставить("ТекстПроизведено", НСтр("ru = 'Собрано'"));
	КонецЕсли;
	ОбластьШапка.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.Вывести(ОбластьШапка);
	#КонецОбласти
	
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	ЗаполнитьСтрокиРекурсивно(СтруктураСерииДерево, ОбластьСтрока, 0, ДокументРезультат);
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрименениеСерииНоменклатуры(Параметры)
	
	ПрименениеСерииНоменклатурыДерево = Новый ДеревоЗначений;
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Произведено", Новый ОписаниеТипов("Число"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("Строка"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("НоменклатураПредставление", Новый ОписаниеТипов("Строка"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("СерияПредставление", Новый ОписаниеТипов("Строка"));
	
	ПрименениеСерииКоллекция = ПрименениеСерииНоменклатурыДерево.Строки;
	
	СписокНоменклатуры = Новый ТаблицаЗначений;
	СписокНоменклатуры.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	СписокНоменклатуры.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	СписокНоменклатуры.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	СписокНоменклатуры.Колонки.Добавить("Строки");
	
	НоваяСтрока = СписокНоменклатуры.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Параметры);
	НоваяСтрока.Строки = ПрименениеСерииКоллекция;
	
	// Для предотвращения зацикливания
	ОтработаннаяНоменклатура = Новый ТаблицаЗначений;
	ОтработаннаяНоменклатура.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ОтработаннаяНоменклатура.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ОтработаннаяНоменклатура.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	
	ЗаполнитьЗначенияСвойств(ОтработаннаяНоменклатура.Добавить(), Параметры);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пока СписокНоменклатуры.Количество() <> 0 Цикл
		
		НовыйСписокНоменклатуры = СписокНоменклатуры.СкопироватьКолонки();
		
		ПроизведенныеСерии = ПроизведенныеСерии(СписокНоменклатуры);
		Для каждого СтрокаНоменклатура Из СписокНоменклатуры Цикл
			
			СтруктураПоиска = Новый Структура("НоменклатураСписка, СерияСписка",
				СтрокаНоменклатура.Номенклатура, СтрокаНоменклатура.Серия);
			
	  		СписокСтрок = ПроизведенныеСерии.НайтиСтроки(СтруктураПоиска);
			Для каждого СтрокаСерияИзделия Из СписокСтрок Цикл
				
				НоваяСерия = СтрокаНоменклатура.Строки.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСерия, СтрокаСерияИзделия);
				
				НоваяСерия.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
					СтрокаСерияИзделия.НоменклатураПредставление,
					СтрокаСерияИзделия.ХарактеристикаПредставление);
																
				Если ЗначениеЗаполнено(НоваяСерия.Серия) Тогда
					
					СтруктураПоиска = Новый Структура("Номенклатура, Характеристика, Серия");
					ЗаполнитьЗначенияСвойств(СтруктураПоиска, НоваяСерия);
					
					СписокСтрок = ОтработаннаяНоменклатура.НайтиСтроки(СтруктураПоиска);
					
					Если СписокСтрок.Количество() = 0 Тогда
						
						НоваяНоменклатура = НовыйСписокНоменклатуры.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяНоменклатура, НоваяСерия);
						НоваяНоменклатура.Строки = НоваяСерия.Строки;
						
						ЗаполнитьЗначенияСвойств(ОтработаннаяНоменклатура.Добавить(), НоваяСерия);
						
					КонецЕсли;
					
				КонецЕсли; 
				
			КонецЦикла; 
			
		КонецЦикла;
		
		СписокНоменклатуры = НовыйСписокНоменклатуры.Скопировать();
		
	КонецЦикла; 
	
	Возврат ПрименениеСерииНоменклатурыДерево;

КонецФункции

Функция ПроизведенныеСерии(СписокНоменклатуры)
	
	ТекстыЗапроса = Новый Массив;
	
	#Область СписокНоменклатуры
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Характеристика КАК Справочник.ХарактеристикиНоменклатуры) КАК Характеристика,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Серия КАК Справочник.СерииНоменклатуры) КАК Серия
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	&СписокНоменклатуры КАК СписокНоменклатуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия");
	
	#КонецОбласти
	
	//++ НЕ УТ
	#Область РасходСерийПриПроизводстве21
	
	//++ НЕ УТКА
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства) КАК Документ,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства).Распоряжение КАК Распоряжение,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства).КодСтроки КАК КодСтроки,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства).КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства).Этап КАК Этап,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства).НоменклатураПолуфабриката КАК НоменклатураПолуфабриката,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства).ХарактеристикаПолуфабриката КАК ХарактеристикаПолуфабриката,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.МаршрутныйЛистПроизводства).НомерПартии КАК НомерПартии,
	|	ДвижениеСерии.КоличествоОборот КАК Количество
	|ПОМЕСТИТЬ РасходСерииПоГрафикуПроизводства
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			(Номенклатура, Характеристика, Серия) В
	|					(ВЫБРАТЬ
	|						СписокНоменклатуры.Номенклатура,
	|						СписокНоменклатуры.Характеристика,
	|						СписокНоменклатуры.Серия
	|					ИЗ
	|						СписокНоменклатуры)
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПотреблениеМатериаловПриПроизводстве)
	|				И Документ ССЫЛКА Документ.МаршрутныйЛистПроизводства) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Распоряжение,
	|	КодСтроки,
	|	НоменклатураПолуфабриката,
	|	ХарактеристикаПолуфабриката
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ДвижениеСерии.Документ КАК Документ,
	|	ДокументРаспределение.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ДокументРаспределение.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	СУММА(ДокументРаспределение.Количество) КАК Количество
	|ПОМЕСТИТЬ РаспределениеЗатратНаЭтапыГрафика
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			(Номенклатура, Характеристика, Серия) В
	|					(ВЫБРАТЬ
	|						СписокНоменклатуры.Номенклатура,
	|						СписокНоменклатуры.Характеристика,
	|						СписокНоменклатуры.Серия
	|					ИЗ
	|						СписокНоменклатуры)
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.СписаниеМатериаловНаЗатраты)
	|				И Документ ССЫЛКА Документ.РаспределениеПроизводственныхЗатрат) КАК ДвижениеСерии
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РаспределениеПроизводственныхЗатрат.ЭтапыГрафикаПроизводства КАК ДокументРаспределение
	|	ПО ДокументРаспределение.Ссылка = ДвижениеСерии.Документ
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвижениеСерии.Номенклатура,
	|	ДвижениеСерии.Характеристика,
	|	ДвижениеСерии.Серия,
	|	ДвижениеСерии.Документ,
	|	ДокументРаспределение.ЗаказНаПроизводство,
	|	ДокументРаспределение.КодСтрокиПродукция
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаказНаПроизводство,
	|	КодСтрокиПродукция");
	//-- НЕ УТКА
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ДвижениеСерии.Документ КАК Документ
	|ПОМЕСТИТЬ СписаниеЗатратНаВыпускБезРаспоряжений
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			(Номенклатура, Характеристика, Серия) В
	|					(ВЫБРАТЬ
	|						СписокНоменклатуры.Номенклатура,
	|						СписокНоменклатуры.Характеристика,
	|						СписокНоменклатуры.Серия
	|					ИЗ
	|						СписокНоменклатуры)
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.СписаниеМатериаловНаЗатраты)
	|				И Документ ССЫЛКА Документ.СписаниеЗатратНаВыпуск) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ");
	
	#КонецОбласти
	//-- НЕ УТ
	
	//++ НЕ УТКА
	#Область ДокументыРасходаСерийПриПроизводстве21
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасходСерии.Номенклатура КАК Номенклатура,
	|	РасходСерии.Характеристика КАК Характеристика,
	|	РасходСерии.Серия КАК Серия,
	|	МаршрутныйЛистПроизводства.Ссылка КАК Ссылка,
	|	МаршрутныйЛистПроизводства.Распоряжение КАК Распоряжение,
	|	МаршрутныйЛистПроизводства.КодСтроки КАК КодСтроки,
	|	МаршрутныйЛистПроизводства.Этап КАК Этап
	|ПОМЕСТИТЬ МаршрутныеЛисты
	|ИЗ
	|	РасходСерииПоГрафикуПроизводства КАК РасходСерии
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = РасходСерии.Распоряжение)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = РасходСерии.КодСтроки)
	|			И (МаршрутныйЛистПроизводства.НомерПартии = РасходСерии.НомерПартии)
	|			И (МаршрутныйЛистПроизводства.НоменклатураПолуфабриката = РасходСерии.НоменклатураПолуфабриката)
	|			И (МаршрутныйЛистПроизводства.ХарактеристикаПолуфабриката = РасходСерии.ХарактеристикаПолуфабриката)
	|			И (МаршрутныйЛистПроизводства.Проведен)
	|			И (МаршрутныйЛистПроизводства.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыМаршрутныхЛистовПроизводства.Отменен))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасходСерии.Номенклатура КАК Номенклатура,
	|	РасходСерии.Характеристика КАК Характеристика,
	|	РасходСерии.Серия КАК Серия,
	|	МаршрутныйЛистПроизводства.Ссылка КАК Ссылка,
	|	МаршрутныйЛистПроизводства.Распоряжение КАК Распоряжение,
	|	МаршрутныйЛистПроизводства.КодСтроки КАК КодСтроки,
	|	МаршрутныйЛистПроизводства.Этап КАК Этап
	|ИЗ
	|	РаспределениеЗатратНаЭтапыГрафика КАК РасходСерии
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = РасходСерии.ЗаказНаПроизводство)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = РасходСерии.КодСтрокиПродукция)
	|			И (МаршрутныйЛистПроизводства.Проведен)
	|			И (МаршрутныйЛистПроизводства.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыМаршрутныхЛистовПроизводства.Отменен))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МаршрутныеЛисты.Номенклатура КАК Номенклатура,
	|	ВЫРАЗИТЬ(МаршрутныеЛисты.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры,
	|	МаршрутныеЛисты.Характеристика КАК Характеристика,
	|	МаршрутныеЛисты.Серия КАК Серия,
	|	МаршрутныеЛисты.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ МаршрутныеЛистыСписка
	|ИЗ
	|	МаршрутныеЛисты КАК МаршрутныеЛисты
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Номенклатура,
	|	Характеристика");
	
	#КонецОбласти
	//-- НЕ УТКА
	
	//++ НЕ УТКА
	#Область РасходСерийПриПроизводстве22
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ДвижениеСерии.Документ КАК Документ
	|ПОМЕСТИТЬ РасходСерийПриПроизводствеБезЗаказа
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			(Номенклатура, Характеристика, Серия) В
	|					(ВЫБРАТЬ
	|						СписокНоменклатуры.Номенклатура,
	|						СписокНоменклатуры.Характеристика,
	|						СписокНоменклатуры.Серия
	|					ИЗ
	|						СписокНоменклатуры)
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПередачаВПроизводствоОтгрузка)
	|				И Документ ССЫЛКА Документ.ПроизводствоБезЗаказа) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.ЭтапПроизводства2_2).ВыпускающийЭтап КАК ВыпускающийЭтап
	|ПОМЕСТИТЬ РасходСерийВЭтапахПроизводства
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			(Номенклатура, Характеристика, Серия) В
	|					(ВЫБРАТЬ
	|						СписокНоменклатуры.Номенклатура,
	|						СписокНоменклатуры.Характеристика,
	|						СписокНоменклатуры.Серия
	|					ИЗ
	|						СписокНоменклатуры)
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПотреблениеМатериаловПриПроизводстве)
	|				И Документ ССЫЛКА Документ.ЭтапПроизводства2_2) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВыпускающийЭтап");
	#КонецОбласти
	//-- НЕ УТКА
	
	//++ НЕ УТКА
	#Область ПриходСерийПриПроизводстве22
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ
	|	ЭтапПроизводства2_2.Ссылка КАК Ссылка,
	|	ЭтапПроизводства2_2.ВыпускающийЭтап,
	|	ЭтапПроизводства2_2.Подразделение
	|ПОМЕСТИТЬ ЭтапыПроизводства
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
	|ГДЕ
	|	ЭтапПроизводства2_2.Проведен
	|	И ЭтапПроизводства2_2.ВыпускающийЭтап В
	|			(ВЫБРАТЬ
	|				РасходСерий.ВыпускающийЭтап
	|			ИЗ
	|				РасходСерийВЭтапахПроизводства КАК РасходСерий)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапыПроизводства.ВыпускающийЭтап КАК ВыпускающийЭтап,
	|	ТаблицаВыпуск.Ссылка КАК Ссылка,
	|	ТаблицаВыпуск.Номенклатура КАК Номенклатура,
	|	ТаблицаВыпуск.Характеристика КАК Характеристика,
	|	ТаблицаВыпуск.Назначение КАК Назначение,
	|	ТаблицаВыпуск.Получатель КАК Получатель,
	|	ТаблицаВыпуск.Произведено КАК Произведено,
	|	ТаблицаВыпуск.ДатаПроизводства КАК ДатаПроизводства,
	|	ТаблицаВыпуск.Серия КАК Серия,
	|	СУММА(ТаблицаВыпуск.Количество) КАК Количество
	|ПОМЕСТИТЬ ЭтапыВыходныеИзделия
	|ИЗ
	|	ЭтапыПроизводства КАК ЭтапыПроизводства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ТаблицаВыпуск
	|		ПО ЭтапыПроизводства.Ссылка = ТаблицаВыпуск.Ссылка
	|ГДЕ
	|	ТаблицаВыпуск.Произведено = ИСТИНА
	|	И ТаблицаВыпуск.Получатель ССЫЛКА Справочник.Склады
	|	И ВЫРАЗИТЬ(ТаблицаВыпуск.Получатель КАК Справочник.Склады).ЦеховаяКладовая
	|	И ВЫРАЗИТЬ(ТаблицаВыпуск.Получатель КАК Справочник.Склады).Подразделение = ЭтапыПроизводства.Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаВыпуск.Ссылка,
	|	ТаблицаВыпуск.Произведено,
	|	ТаблицаВыпуск.Серия,
	|	ТаблицаВыпуск.Получатель,
	|	ТаблицаВыпуск.Характеристика,
	|	ТаблицаВыпуск.Назначение,
	|	ТаблицаВыпуск.ДатаПроизводства,
	|	ЭтапыПроизводства.ВыпускающийЭтап,
	|	ТаблицаВыпуск.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	Получатель,
	|	Произведено,
	|	ДатаПроизводства
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапыПроизводства.ВыпускающийЭтап КАК ВыпускающийЭтап,
	|	ТаблицаВыпуск.Ссылка КАК Ссылка,
	|	ТаблицаВыпуск.Номенклатура КАК Номенклатура,
	|	ТаблицаВыпуск.Характеристика КАК Характеристика,
	|	ТаблицаВыпуск.Назначение КАК Назначение,
	|	ТаблицаВыпуск.Получатель КАК Получатель,
	|	ТаблицаВыпуск.Произведено КАК Произведено,
	|	ТаблицаВыпуск.ДатаПроизводства КАК ДатаПроизводства,
	|	ТаблицаВыпуск.Серия КАК Серия,
	|	СУММА(ТаблицаВыпуск.Количество) КАК Количество
	|ПОМЕСТИТЬ ЭтапыПобочныеИзделия
	|ИЗ
	|	ЭтапыПроизводства КАК ЭтапыПроизводства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ПобочныеИзделия КАК ТаблицаВыпуск
	|		ПО ЭтапыПроизводства.Ссылка = ТаблицаВыпуск.Ссылка
	|ГДЕ
	|	ТаблицаВыпуск.Произведено = ИСТИНА
	|	И ТаблицаВыпуск.Получатель ССЫЛКА Справочник.Склады
	|	И ВЫРАЗИТЬ(ТаблицаВыпуск.Получатель КАК Справочник.Склады).ЦеховаяКладовая
	|	И ВЫРАЗИТЬ(ТаблицаВыпуск.Получатель КАК Справочник.Склады).Подразделение = ЭтапыПроизводства.Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	ЭтапыПроизводства.ВыпускающийЭтап,
	|	ТаблицаВыпуск.Получатель,
	|	ТаблицаВыпуск.Серия,
	|	ТаблицаВыпуск.Назначение,
	|	ТаблицаВыпуск.Произведено,
	|	ТаблицаВыпуск.Ссылка,
	|	ТаблицаВыпуск.Номенклатура,
	|	ТаблицаВыпуск.Характеристика,
	|	ТаблицаВыпуск.ДатаПроизводства
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	Получатель,
	|	Произведено,
	|	ДатаПроизводства
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвижениеПродукцииИМатериалов.Ссылка КАК Ссылка,
	|	ВЫРАЗИТЬ(ДвижениеПродукцииИМатериалов.Распоряжение КАК Документ.ЭтапПроизводства2_2).ВыпускающийЭтап КАК ВыпускающийЭтап
	|ПОМЕСТИТЬ ПередачиПродукции
	|ИЗ
	|	Документ.ДвижениеПродукцииИМатериалов КАК ДвижениеПродукцииИМатериалов
	|ГДЕ
	|	ДвижениеПродукцииИМатериалов.Проведен
	|	И ДвижениеПродукцииИМатериалов.Распоряжение В
	|			(ВЫБРАТЬ
	|				ЭтапыПроизводства.Ссылка
	|			ИЗ
	|				ЭтапыПроизводства КАК ЭтапыПроизводства)
	|	И ДвижениеПродукцииИМатериалов.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаПродукцииИзПроизводства)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПередачиПродукции.ВыпускающийЭтап КАК ВыпускающийЭтап,
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Назначение КАК Назначение,
	|	ТаблицаТовары.НазначениеОтправителя КАК НазначениеОтправителя,
	|	ТаблицаТовары.Серия КАК Серия,
	|	СУММА(ТаблицаТовары.Количество) КАК Количество
	|ПОМЕСТИТЬ ПереданнаяПродукция
	|ИЗ
	|	ПередачиПродукции КАК ПередачиПродукции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДвижениеПродукцииИМатериалов.Товары КАК ТаблицаТовары
	|		ПО ПередачиПродукции.Ссылка = ТаблицаТовары.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.НазначениеОтправителя,
	|	ПередачиПродукции.ВыпускающийЭтап,
	|	ТаблицаТовары.Ссылка,
	|	ТаблицаТовары.Характеристика,
	|	ТаблицаТовары.Серия,
	|	ТаблицаТовары.Назначение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	НазначениеОтправителя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВыпуск.ВыпускающийЭтап КАК ВыпускающийЭтап,
	|	ТаблицаВыпуск.Номенклатура КАК Номенклатура,
	|	ТаблицаВыпуск.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(ТаблицаСерии.Серия, ТаблицаВыпуск.Серия) КАК Серия,
	|	ЕСТЬNULL(ТаблицаСерии.Количество, ТаблицаВыпуск.Количество) КАК Количество
	|ПОМЕСТИТЬ ПриходСерийВЭтапахПроизводства
	|ИЗ
	|	ЭтапыВыходныеИзделия КАК ТаблицаВыпуск
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ВыходныеИзделияСерии КАК ТаблицаСерии
	|		ПО ТаблицаВыпуск.Ссылка = ТаблицаСерии.Ссылка
	|			И ТаблицаВыпуск.Номенклатура = ТаблицаСерии.Номенклатура
	|			И ТаблицаВыпуск.Характеристика = ТаблицаСерии.Характеристика
	|			И ТаблицаВыпуск.Назначение = ТаблицаСерии.Назначение
	|			И ТаблицаВыпуск.Получатель = ТаблицаСерии.Получатель
	|			И ТаблицаВыпуск.Произведено = ТаблицаСерии.Произведено
	|			И ТаблицаВыпуск.ДатаПроизводства = ТаблицаСерии.ДатаПроизводства
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаВыпуск.ВыпускающийЭтап,
	|	ТаблицаВыпуск.Номенклатура,
	|	ТаблицаВыпуск.Характеристика,
	|	ЕСТЬNULL(ТаблицаСерии.Серия, ТаблицаВыпуск.Серия),
	|	ЕСТЬNULL(ТаблицаСерии.Количество, ТаблицаВыпуск.Количество)
	|ИЗ
	|	ЭтапыПобочныеИзделия КАК ТаблицаВыпуск
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ПобочныеИзделияСерии КАК ТаблицаСерии
	|		ПО ТаблицаВыпуск.Ссылка = ТаблицаСерии.Ссылка
	|			И ТаблицаВыпуск.Номенклатура = ТаблицаСерии.Номенклатура
	|			И ТаблицаВыпуск.Характеристика = ТаблицаСерии.Характеристика
	|			И ТаблицаВыпуск.Назначение = ТаблицаСерии.Назначение
	|			И ТаблицаВыпуск.Получатель = ТаблицаСерии.Получатель
	|			И ТаблицаВыпуск.Произведено = ТаблицаСерии.Произведено
	|			И ТаблицаВыпуск.ДатаПроизводства = ТаблицаСерии.ДатаПроизводства
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаТовары.ВыпускающийЭтап,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ЕСТЬNULL(ТаблицаСерии.Серия, ТаблицаТовары.Серия),
	|	ЕСТЬNULL(ТаблицаСерии.Количество, ТаблицаТовары.Количество)
	|ИЗ
	|	ПереданнаяПродукция КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДвижениеПродукцииИМатериалов.Серии КАК ТаблицаСерии
	|		ПО ТаблицаТовары.Ссылка = ТаблицаСерии.Ссылка
	|			И ТаблицаТовары.Номенклатура = ТаблицаСерии.Номенклатура
	|			И ТаблицаТовары.Характеристика = ТаблицаСерии.Характеристика
	|			И ТаблицаТовары.Назначение = ТаблицаСерии.Назначение
	|			И ТаблицаТовары.НазначениеОтправителя = ТаблицаСерии.НазначениеОтправителя
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВыпускающийЭтап");
	#КонецОбласти
	//-- НЕ УТКА
	
	#Область РасходСерииПриСборке
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.СборкаТоваров) КАК Документ,
	|	ДвижениеСерии.КоличествоОборот КАК Количество
	|ПОМЕСТИТЬ РасходСерииПриСборке
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			(Номенклатура, Характеристика, Серия) В
	|					(ВЫБРАТЬ
	|						СписокНоменклатуры.Номенклатура,
	|						СписокНоменклатуры.Характеристика,
	|						СписокНоменклатуры.Серия
	|					ИЗ
	|						СписокНоменклатуры КАК СписокНоменклатуры)
	|				И СкладскаяОперация В (ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаКомплектующихДляСборки),
	|										ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаКомплектовДляРазборки))) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Документ");
	
	#КонецОбласти
	
	#Область ПриходСерий
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.НоменклатураСписка КАК НоменклатураСписка,
	|	ВложенныйЗапрос.ХарактеристикаСписка КАК ХарактеристикаСписка, 
	|	ВложенныйЗапрос.СерияСписка КАК СерияСписка,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ВложенныйЗапрос.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ВложенныйЗапрос.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ВложенныйЗапрос.Серия КАК Серия,
	|	ВложенныйЗапрос.Серия.Представление КАК СерияПредставление,
	|	СУММА(ВложенныйЗапрос.Произведено) КАК Произведено
	|ИЗ
	|(
	|	ВЫБРАТЬ
	|		РасходСерииПриСборке.Номенклатура КАК НоменклатураСписка,
	|		РасходСерииПриСборке.Характеристика КАК ХарактеристикаСписка,
	|		РасходСерииПриСборке.Серия КАК СерияСписка,
	|		ПоступлениеСерииПриСборке.Номенклатура КАК Номенклатура,
	|		ПоступлениеСерииПриСборке.Характеристика КАК Характеристика,
	|		ПоступлениеСерииПриСборке.Серия КАК Серия,
	|		ПоступлениеСерииПриСборке.КоличествоОборот КАК Произведено
	|	ИЗ 	
	|		РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			Документ В
	|					(ВЫБРАТЬ
	|						РасходСерииПриСборке.Документ
	|					ИЗ
	|						РасходСерииПриСборке КАК РасходСерииПриСборке)
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПриемкаПродукцииИзПроизводства)) КАК ПоступлениеСерииПриСборке
	|		ЛЕВОЕ СОЕДИНЕНИЕ РасходСерииПриСборке КАК РасходСерииПриСборке
	|		ПО РасходСерииПриСборке.Документ = ПоступлениеСерииПриСборке.Документ
	//++ НЕ УТКА
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		МаршрутныеЛистыСписка.Номенклатура КАК НоменклатураСписка,
	|		МаршрутныеЛистыСписка.Характеристика КАК ХарактеристикаСписка,
	|		МаршрутныеЛистыСписка.Серия КАК СерияСписка,
	|		ТаблицаВыпуск.Номенклатура КАК Номенклатура,
	|		ТаблицаВыпуск.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия 
	|		КОНЕЦ КАК Серия,
	|		СУММА(ЕСТЬNULL(ТаблицаСерии.КоличествоФакт, ТаблицаВыпуск.КоличествоФакт)) КАК Произведено
	|	ИЗ 
	|		МаршрутныеЛистыСписка КАК МаршрутныеЛистыСписка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства.ВыходныеИзделия КАК ТаблицаВыпуск
	|			ПО ТаблицаВыпуск.Ссылка = МаршрутныеЛистыСписка.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства.ВыходныеИзделияСерии КАК ТаблицаСерии
	|			ПО ТаблицаСерии.Ссылка = ТаблицаВыпуск.Ссылка
	|				И ТаблицаСерии.Номенклатура = ТаблицаВыпуск.Номенклатура
	|				И ТаблицаСерии.Характеристика = ТаблицаВыпуск.Характеристика
	|				И ТаблицаСерии.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	ГДЕ
	|		ТаблицаВыпуск.КоличествоФакт <> 0
	|
	|	СГРУППИРОВАТЬ ПО
	|		МаршрутныеЛистыСписка.Номенклатура,
	|		МаршрутныеЛистыСписка.Характеристика,
	|		МаршрутныеЛистыСписка.Серия,
	|		ТаблицаВыпуск.Ссылка,
	|		ТаблицаВыпуск.Номенклатура,
	|		ТаблицаВыпуск.Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия
	|		КОНЕЦ
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		МаршрутныеЛистыСписка.Номенклатура КАК НоменклатураСписка,
	|		МаршрутныеЛистыСписка.Характеристика КАК ХарактеристикаСписка,
	|		МаршрутныеЛистыСписка.Серия КАК СерияСписка,
	|		ТаблицаВыпуск.Номенклатура КАК Номенклатура,
	|		ТаблицаВыпуск.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия 
	|		КОНЕЦ КАК Серия,
	|		СУММА(ЕСТЬNULL(ТаблицаСерии.Количество, ТаблицаВыпуск.Количество)) КАК Произведено
	|	ИЗ 
	|		МаршрутныеЛистыСписка КАК МаршрутныеЛистыСписка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Товары КАК ТаблицаВыпуск
	|			ПО ТаблицаВыпуск.Распоряжение = МаршрутныеЛистыСписка.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Серии КАК ТаблицаСерии
	|			ПО ТаблицаСерии.Ссылка = ТаблицаВыпуск.Ссылка
	|				И ТаблицаСерии.Номенклатура = ТаблицаВыпуск.Номенклатура
	|				И ТаблицаСерии.Характеристика = ТаблицаВыпуск.Характеристика
	|				И ТаблицаСерии.Склад = ТаблицаВыпуск.Склад
	|				И ТаблицаСерии.Подразделение = ТаблицаВыпуск.Подразделение
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерийСклад
	|			ПО ПолитикиУчетаСерийСклад.Ссылка = МаршрутныеЛистыСписка.ВидНоменклатуры
	|				И ПолитикиУчетаСерийСклад.Склад = ТаблицаВыпуск.Склад
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерийПодразделение
	|			ПО ПолитикиУчетаСерийПодразделение.Ссылка = МаршрутныеЛистыСписка.ВидНоменклатуры
	|				И ПолитикиУчетаСерийПодразделение.Склад = ТаблицаВыпуск.Подразделение
	|
	|	ГДЕ
	|		ТаблицаВыпуск.Ссылка.Проведен
	|		И НЕ ЕСТЬNULL(ПолитикиУчетаСерийСклад.ПолитикаУчетаСерий.УказыватьДляИзделийПриВыполненииМаршрутныхЛистов,
	|				ЕСТЬNULL(ПолитикиУчетаСерийПодразделение.ПолитикаУчетаСерий.УказыватьДляИзделийПриВыполненииМаршрутныхЛистов, ЛОЖЬ))
	|		И ЕСТЬNULL(ПолитикиУчетаСерийСклад.ПолитикаУчетаСерий.УказыватьПриПриемкеПродукцииИзПроизводства,
	|				ЕСТЬNULL(ПолитикиУчетаСерийПодразделение.ПолитикаУчетаСерий.УказыватьПриПриемкеПродукцииИзПроизводства, ЛОЖЬ))
	|
	|	СГРУППИРОВАТЬ ПО
	|		МаршрутныеЛистыСписка.Номенклатура,
	|		МаршрутныеЛистыСписка.Характеристика,
	|		МаршрутныеЛистыСписка.Серия,
	|		ТаблицаВыпуск.Номенклатура,
	|		ТаблицаВыпуск.Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия
	|		КОНЕЦ
	//-- НЕ УТКА
	//++ НЕ УТ
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Номенклатура КАК НоменклатураСписка,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Характеристика КАК ХарактеристикаСписка,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Серия КАК СерияСписка,
	|		ТаблицаВыпуск.Номенклатура КАК Номенклатура,
	|		ТаблицаВыпуск.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия 
	|		КОНЕЦ КАК Серия,
	|		СУММА(ЕСТЬNULL(ТаблицаСерии.Количество, ТаблицаВыпуск.Количество)) КАК Произведено
	|	ИЗ 
	|		СписаниеЗатратНаВыпускБезРаспоряжений КАК СписаниеЗатратНаВыпускБезРаспоряжений
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеЗатратНаВыпуск.ВыходныеИзделия КАК ТаблицаВыходныеИзделия
	|			ПО ТаблицаВыходныеИзделия.Ссылка = СписаниеЗатратНаВыпускБезРаспоряжений.Документ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Товары КАК ТаблицаВыпуск
	|			ПО ТаблицаВыпуск.Ссылка = ТаблицаВыходныеИзделия.Распоряжение
	|				И ТаблицаВыпуск.Номенклатура = ТаблицаВыходныеИзделия.Номенклатура
	|				И ТаблицаВыпуск.Характеристика = ТаблицаВыходныеИзделия.Характеристика
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Серии КАК ТаблицаСерии
	|			ПО ТаблицаСерии.Ссылка = ТаблицаВыпуск.Ссылка
	|				И ТаблицаСерии.Номенклатура = ТаблицаВыпуск.Номенклатура
	|				И ТаблицаСерии.Характеристика = ТаблицаВыпуск.Характеристика
	|				И ТаблицаСерии.Склад = ТаблицаВыпуск.Склад
	|				И ТаблицаСерии.Подразделение = ТаблицаВыпуск.Подразделение
	|
	|	СГРУППИРОВАТЬ ПО
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Номенклатура,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Характеристика,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Серия,
	|		ТаблицаВыпуск.Номенклатура,
	|		ТаблицаВыпуск.Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия
	|		КОНЕЦ
	//-- НЕ УТ
	//++ НЕ УТКА
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		РасходСерийПриПроизводствеБезЗаказа.Номенклатура КАК НоменклатураСписка,
	|		РасходСерийПриПроизводствеБезЗаказа.Характеристика КАК ХарактеристикаСписка,
	|		РасходСерийПриПроизводствеБезЗаказа.Серия КАК СерияСписка,
	|		ПоступлениеСерий.Номенклатура КАК Номенклатура,
	|		ПоступлениеСерий.Характеристика КАК Характеристика,
	|		ПоступлениеСерий.Серия КАК Серия,
	|		ПоступлениеСерий.КоличествоОборот КАК Произведено
	|	ИЗ 
	|		РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|				,
	|				,
	|				,
	|				Документ В
	|						(ВЫБРАТЬ
	|							РасходСерийПриПроизводствеБезЗаказа.Документ
	|							ИЗ
	|						РасходСерийПриПроизводствеБезЗаказа КАК РасходСерийПриПроизводствеБезЗаказа)
	|					И СкладскаяОперация В (
	|											ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПриемкаПродукцииИзПроизводства),
	|											ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПриемкаИзПроизводства)
	|											)) КАК ПоступлениеСерий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РасходСерийПриПроизводствеБезЗаказа КАК РасходСерийПриПроизводствеБезЗаказа
	|		ПО РасходСерийПриПроизводствеБезЗаказа.Документ = ПоступлениеСерий.Документ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РасходСерий.Номенклатура КАК НоменклатураСписка,
	|		РасходСерий.Характеристика КАК ХарактеристикаСписка,
	|		РасходСерий.Серия КАК СерияСписка,
	|		ПриходСерий.Номенклатура КАК Номенклатура,
	|		ПриходСерий.Характеристика КАК Характеристика,
	|		ПриходСерий.Серия КАК Серия,
	|		ПриходСерий.Количество КАК Произведено
	|	ИЗ 
	|		ПриходСерийВЭтапахПроизводства КАК ПриходСерий
	|			ЛЕВОЕ СОЕДИНЕНИЕ РасходСерийВЭтапахПроизводства КАК РасходСерий
	|			ПО ПриходСерий.ВыпускающийЭтап = РасходСерий.ВыпускающийЭтап
	|
	//-- НЕ УТКА
	|) КАК ВложенныйЗапрос
	|ГДЕ
	|	НЕ(ВложенныйЗапрос.НоменклатураСписка = ВложенныйЗапрос.Номенклатура
	|		И ВложенныйЗапрос.ХарактеристикаСписка = ВложенныйЗапрос.Характеристика
	|		И ВложенныйЗапрос.СерияСписка = ВложенныйЗапрос.Серия)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.НоменклатураСписка,
	|	ВложенныйЗапрос.ХарактеристикаСписка,
	|	ВложенныйЗапрос.СерияСписка,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Характеристика,
	|	ВложенныйЗапрос.Серия
	|
	|УПОРЯДОЧИТЬ ПО
	|	НоменклатураПредставление,
	|	ХарактеристикаПредставление,
	|	СерияПредставление");
	#КонецОбласти
	
	Разделитель = 
	"
	|;
	|/////////////////////////////////////////////////////////////
	|";
	ТекстЗапроса = СтрСоединить(ТекстыЗапроса, Разделитель);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Результат.Индексы.Добавить("НоменклатураСписка,СерияСписка");
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьСтрокиРекурсивно(СтруктураСерииДерево, ОбластьСтрока, Уровень, ДокументРезультат)

	Для каждого СтрокаДерева Из СтруктураСерииДерево.Строки Цикл
		
		ПараметрыОбласти = Новый Структура("Номенклатура,Серия,НоменклатураПредставление,
											|СерияПредставление,ЕдиницаИзмерения,Произведено");
		ЗаполнитьЗначенияСвойств(ПараметрыОбласти, СтрокаДерева);
		
		СтруктураРасшифровки = Новый Структура("Номенклатура,Характеристика,Серия");
		ЗаполнитьЗначенияСвойств(СтруктураРасшифровки, СтрокаДерева);
		ПараметрыОбласти.Вставить("СтруктураРасшифровки", СтруктураРасшифровки);
		
		ОбластьСтрока.Параметры.Заполнить(ПараметрыОбласти);
		ДокументРезультат.Вывести(ОбластьСтрока, Уровень,, Истина);
		
		ЗаполнитьСтрокиРекурсивно(СтрокаДерева, ОбластьСтрока, Уровень + 1, ДокументРезультат);
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
