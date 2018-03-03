﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Заголовок,ДатаПриема,ТекущаяОрганизация");
	СотрудникСсылка = Параметры.СотрудникСсылка;
	ФизическоеЛицоСсылка = Параметры.ФизическоеЛицоСсылка;
	СозданиеНового = Параметры.СозданиеНового;
	
	ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(ТекущаяОрганизация);
	
	ЦветСтиляРасширеннойПодсказки = Элементы.ГруппаНДФЛИнфо.РасширеннаяПодсказка.ЦветТекста;
	ЦветСтиляПоясняющийОшибкуТекст = ЦветаСтиля.ПоясняющийОшибкуТекст;
	
	ДоступноИзменениеНалоговИВзносов = Пользователи.РолиДоступны("ДобавлениеИзменениеНалоговИВзносов");
	
	СотрудникиФормы.ПрочитатьДанныеИзХранилищаВФорму(
		ЭтаФорма,
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(ИмяФормы),
		Параметры.АдресВХранилище);
		
	ПроинициализироватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СотрудникиКлиент.ЗарегистрироватьОткрытиеФормы(ЭтаФорма, "НалогНаДоходы");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ОтредактированаИстория" И ФизическоеЛицоСсылка = Источник Тогда
		
		Если Параметр.ИмяРегистра = "СтатусФизическихЛицКакНалогоплательщиковНДФЛ" Тогда
			Если СтатусФизическихЛицКакНалогоплательщиковНДФЛНаборЗаписейПрочитан Тогда
				РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(
					ЭтаФорма,
					ФизическоеЛицоСсылка,
					ИмяСобытия,
					Параметр,
					Источник);
				КонецЕсли;
				ОбновитьПолеСтатусПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзмененыВычеты" И Параметр = ЭтаФорма.ФизическоеЛицоСсылка Тогда
		
		ПрочитатьСведенияОВычетахНДФЛ();
		
	ИначеЕсли ИмяСобытия = "ОтредактированыРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей" И Источник = ЭтаФорма.ФизическоеЛицоСсылка Тогда
		
		Если Параметр.Свойство("МассивЗаписей") Тогда
			
			НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Очистить();
			Для каждого СтрокаЗаписи Из Параметр.МассивЗаписей Цикл
				ЗаполнитьЗначенияСвойств(НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Добавить(), СтрокаЗаписи);
			КонецЦикла;
			
			ПрочитатьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей(РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Год);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(
		ЭтаФорма,
		"СтатусФизическихЛицКакНалогоплательщиковНДФЛ",
		ФизическоеЛицоСсылка,
		Отказ);
		
КонецПроцедуры
	
#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусФизическихЛицКакНалогоплательщиковНДФЛСтатусПриИзменении(Элемент)
	ОбновитьПолеСтатусПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
КонецПроцедуры

&НаКлиенте
Процедура СтатусФизическихЛицКакНалогоплательщиковНДФЛПериодПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод)
		Или СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод < '19000101' Тогда
		
		СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период = '19000101';
		
	Иначе
		СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период = СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод;
	КонецЕсли;
	
	ОбновитьПолеСтатусПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежейГодПриИзменении(Элемент)
	
	ПриИзмененииРеквизитыУведомленияИФНС();
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежейГодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПриИзмененииРеквизитыУведомленияИФНС();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СтатусФизическихЛицКакНалогоплательщиковНДФЛИстория(Команда)

	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("СтатусФизическихЛицКакНалогоплательщиковНДФЛ", ФизическоеЛицоСсылка, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИсправитьЗаявлениеНаПредоставлениеСтандартныхВычетов(Команда)

	ПоказатьЗначение(, ЗаявлениеНаПредоставлениеСтандартныхВычетов);

КонецПроцедуры

&НаКлиенте
Процедура ИсправитьУведомлениеОПравеНаИмущественныйВычет(Команда)

	ПоказатьЗначение(, УведомлениеОПравеНаИмущественныйВычет);

КонецПроцедуры

&НаКлиенте
Процедура ВвестиНовоеЗаявлениеНаПредоставлениеСтандартныхВычетов(Команда)

	СотрудникиКлиент.ВвестиНовоеЗаявлениеНаПредоставлениеСтандартныхВычетов(ФизическоеЛицоСсылка, ГоловнаяОрганизация);

КонецПроцедуры

&НаКлиенте
Процедура ВвестиНовоеУведомлениеОПравеНаИмущественныйВычет(Команда)

	СотрудникиКлиент.ВвестиНовоеУведомлениеОПравеНаИмущественныйВычет(ФизическоеЛицоСсылка, ГоловнаяОрганизация);

КонецПроцедуры

&НаКлиенте
Процедура ВсеЗаявленияНаВычеты(Команда)

	СотрудникиКлиент.ОткрытьЖурналЗаявленийНаВычеты(ФизическоеЛицоСсылка);

КонецПроцедуры

&НаКлиенте
Процедура ВвестиПрекращениеСтандартныхВычетовНДФЛ(Команда)

	СотрудникиКлиент.ВвестиДокументПрекращениеСтандартныхВычетовНДФЛ(ФизическоеЛицоСсылка, ГоловнаяОрганизация);

КонецПроцедуры

&НаКлиенте
Процедура ДоходыСПредыдущегоМестаРаботы(Команда)

	СотрудникиКлиент.ОткрытьФормуВводаДоходовСПредыдущегоМестаРаботы(ФизическоеЛицоСсылка, ГоловнаяОрганизация);

КонецПроцедуры

&НаКлиенте
Процедура РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежейПодробнее(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВедущийОбъект", ФизическоеЛицоСсылка);
	ПараметрыОткрытия.Вставить("ГоловнаяОрганизация", ГоловнаяОрганизация);
	ПараметрыОткрытия.Вставить("МассивЗаписей", ЗаписиРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей());
	
	ОткрытьФорму("РегистрСведений.РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Форма.РедактированиеНабораЗаписей", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроинициализироватьФорму()
	
	ПрочитатьСведенияОВычетахНДФЛ();
	
	Если СтатусФизическихЛицКакНалогоплательщиковНДФЛПрежняя = Неопределено Тогда
		РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(
			ЭтаФорма,
			"СтатусФизическихЛицКакНалогоплательщиковНДФЛ",
			ФизическоеЛицоСсылка); 
	КонецЕсли; 
		
	УстановитьДоступностьВводаВычетов();
	ОбновитьПолеСтатусПериод(ЭтаФорма, ТекущаяДатаСеанса());
	
	ТолькоСтатусНалогоплательщика = НЕ ЗначениеЗаполнено(СотрудникСсылка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВычетыСтраницы",
		"Видимость",
		НЕ ТолькоСтатусНалогоплательщика);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДоходыСПредыдущегоМестаРаботы",
		"Видимость",
		НЕ ТолькоСтатусНалогоплательщика);
		
	Если ТолькоСтатусНалогоплательщика Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СтатусДоходыГруппа",
			"Отображение",
			ОтображениеОбычнойГруппы.Нет);
			
	КонецЕсли;
	
	Если НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежейПрочитан = Ложь Тогда
		ПрочитатьНаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей();
	КонецЕсли;
	
	ПрочитатьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСведенияОВычетахНДФЛ()
	
	Если ЗначениеЗаполнено(ФизическоеЛицоСсылка) Тогда
		
		МассивРезультатов = СотрудникиФормы.ПолучитьСведенияОВычетахНДФЛ(ФизическоеЛицоСсылка);
		
		Если МассивРезультатов.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;

		ОрганизацияПоЗаявлению = НеОпределено;
		ОрганизацияПоУведомлению = НеОпределено;
		ВычетыПредоставлялись = Ложь;
		
		ВыборкаСтандартныеВычеты = МассивРезультатов[0][0];
		Если Не ВыборкаСтандартныеВычеты.МесяцРегистрации = Null Тогда
			СтандартныеВычетыНДФЛМесяцСтрокой = Формат(ВыборкаСтандартныеВычеты.МесяцРегистрации, "ДФ='ММММ гггг'");
			ВычетыПредоставлялись = Истина;
		КонецЕсли;
		
		Результат = МассивРезультатов[1];
		Если Результат.Количество() > 0 Тогда
			ВыборкаСтандартныеВычеты = Результат[0];
			СтандартныеВычетыНДФЛКод						= ВыборкаСтандартныеВычеты.КодВычетаЛичный; 
			ЗаявлениеНаПредоставлениеСтандартныхВычетов	= ВыборкаСтандартныеВычеты.Регистратор;
			ЗаявлениеНомер										= ВыборкаСтандартныеВычеты.Номер;
			ЗаявлениеДата										= ВыборкаСтандартныеВычеты.Дата;
			СотрудникПоЗаявлению								= ВыборкаСтандартныеВычеты.Сотрудник;
			ОрганизацияПоЗаявлению								= ВыборкаСтандартныеВычеты.Организация;
		КонецЕсли;
		
		Результат = МассивРезультатов[2];
		Если Результат.Количество() > 0 Тогда
			СтандартныеВычетыНДФЛВычетыНаДетей.Очистить();
			Для Каждого ВыборкаВычетыНаДетей Из Результат Цикл
					
				ЗаполнитьЗначенияСвойств(СтандартныеВычетыНДФЛВычетыНаДетей.Добавить(), ВыборкаВычетыНаДетей);
				ЗаявлениеНаПредоставлениеСтандартныхВычетов	= ВыборкаВычетыНаДетей.Регистратор;
				ЗаявлениеНомер								= ВыборкаВычетыНаДетей.Номер;
				ЗаявлениеДата								= ВыборкаВычетыНаДетей.Дата;
				СотрудникПоЗаявлению						= ВыборкаВычетыНаДетей.Сотрудник;
				ОрганизацияПоЗаявлению						= ВыборкаВычетыНаДетей.Организация;
					
			КонецЦикла;
		КонецЕсли;
			
		Результат = МассивРезультатов[3];
		Если Результат.Количество() > 0 Тогда
			
			ВыборкаИмущВычеты = Результат[0];
			
			// 4D:ERP для Беларуси, Яна, 19.06.2017 9:57:17 
			// Форма "Подоходный налог" спр. "Сотрудники", №15077 
			// {
			ИмущественныеВычетыНДФЛКодНалоговогоОргана			= ВыборкаИмущВычеты.КодНалоговогоОргана; 
			ИмущественныеВычетыНДФЛРасходы						= ВыборкаИмущВычеты.РасходыНаСтроительствоПриобретение;			
			ИмущественныеВычетыНДФЛРасходыНаОбразование			= ВыборкаИмущВычеты.РасходыНаОбразование; 
			ИмущественныеВычетыНДФЛРасходыНаСтрахование		 	= ВыборкаИмущВычеты.РасходыНаСтрахование;
			УведомлениеОПравеНаИмущественныйВычет               = ВыборкаИмущВычеты.Регистратор;
			СотрудникПоУведомлению                             	= ВыборкаИмущВычеты.Сотрудник;
			ОрганизацияПоУведомлению                           	= ВыборкаИмущВычеты.Организация;
			ИмущественныеВычетыНДФЛПрименятьС					= Формат(ВыборкаИмущВычеты.ПрименятьВычетыС, "ДФ='ММММ гггг'");
			ИмущественныеВычетыНДФЛНалоговыйПериод				= ВыборкаИмущВычеты.НалоговыйПериод;
			// }
			// 4D

		Иначе
			УведомлениеОПравеНаИмущественныйВычет = Неопределено;
		КонецЕсли;
		
		Если ЗаявлениеНаПредоставлениеСтандартныхВычетов.Пустая()
			И УведомлениеОПравеНаИмущественныйВычет.Пустая() Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ВычетыСтраницы",
				"ТекущаяСтраница",
				Элементы.ИнфоНадписьОПримененииВычетов);
			
		Иначе 
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ВычетыСтраницы",
				"ТекущаяСтраница",
				Элементы.ДанныеОПримененииВычетов);
			
			ДоступностьИсправитьЗаявлениеНаПредоставлениеСтандартныхВычетов = Истина;
			ДоступностьИсправитьУведомлениеОИмущественномВычете = Истина;
			
			Если ОрганизацияПоЗаявлению = НеОпределено Тогда
				
				ЗаявлениеНаПредоставлениеСтандартныхВычетовИнфо = НСтр("ru = 'Стандартные вычеты не применяются. Можете ввести заявление о предоставлении стандартных вычетов'");
				ДоступностьИсправитьЗаявлениеНаПредоставлениеСтандартныхВычетов = Ложь;
				
			ИначеЕсли ОрганизацияПоЗаявлению <> ГоловнаяОрганизация Тогда
				
				ЗаявлениеНаПредоставлениеСтандартныхВычетовИнфо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Вычеты применяются в организации %1. Чтобы начать применение вычетов в организации %2 введите новое заявление о предоставлении вычетов'"),
					ОрганизацияПоЗаявлению,
					ГоловнаяОрганизация);
				ДоступностьИсправитьЗаявлениеНаПредоставлениеСтандартныхВычетов = Ложь;
				
			Иначе
				
				ЗаявлениеНаПредоставлениеСтандартныхВычетовИнфо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Вычеты предоставляются по заявлению номер %1 от %2'"),
					ЗаявлениеНомер,
					Формат(ЗаявлениеДата,"ДЛФ=DD"));
					
			КонецЕсли;
				
			Если НЕ ЗначениеЗаполнено(УведомлениеОПравеНаИмущественныйВычет) Тогда
				
				// 4D:ERP для Беларуси, Яна, 19.06.2017 9:57:17 
				// Форма "Подоходный налог" спр. "Сотрудники", №15077 
				// {
				УведомлениеОПравеНаИмущественныйВычетИнфо = НСтр("ru = 'Имущественные вычеты не применяются. Можете ввести новое уведомление о предоставлении вычетов'");
				// }
				// 4D

				ДоступностьИсправитьУведомлениеОИмущественномВычете = Ложь;
				
			Иначе
				
				УведомлениеОПравеНаИмущественныйВычетИнфо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Имущественные или социальные вычеты предоставляются по уведомлению номер %1 от %2'"),
					ВыборкаИмущВычеты.Номер,
					Формат(ВыборкаИмущВычеты.Дата, "ДЛФ=DD"));
					
			КонецЕсли;
				
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ИсправитьЗаявлениеНаПредоставлениеСтандартныхВычетов",
				"Доступность",
				ДоступностьИсправитьЗаявлениеНаПредоставлениеСтандартныхВычетов);
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ИсправитьУведомлениеОИмущественномВычете",
				"Доступность",
				ДоступностьИсправитьУведомлениеОИмущественномВычете);
			
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ВычетыСтраницы",
			"ТекущаяСтраница",
			Элементы.ИнфоНадписьОПримененииВычетов);
		
	КонецЕсли;
	
	УстановитьИнфоНадписьВычеты(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Отказ, ОповещениеЗавершения = Неопределено) Экспорт
	
	Если Не Модифицированность Тогда
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		Возврат;
	КонецЕсли; 
		
	Если Не СозданиеНового И Не Отказ Тогда
		ЗапроситьРежимИзмененияСтатусаНалогоплательщика(СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период, Отказ, ОповещениеЗавершения);
	Иначе 
		СохранитьДанныеЗавершение(Отказ, ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеЗавершение(Отказ, ОповещениеЗавершения) 
	
	Если Не Отказ Тогда
		
		СохранитьРеквизитыУведомленияПриЗакрытии();
		
		Если ПроверитьЗаполнение() Тогда
			
			ВозвращаемыйПараметр = Новый Структура;
			ВозвращаемыйПараметр.Вставить("ИмяФормы", ИмяФормы);
			ВозвращаемыйПараметр.Вставить("АдресВХранилище", АдресДанныхДополнительнойФормыНаСервере(СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(ИмяФормы)));
			
			Оповестить(
			"ИзмененыДанныеДополнительнойФормы",
			ВозвращаемыйПараметр,
			ВладелецФормы);
			
		Иначе
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиенте(ЗакрытьФорму = Истина) Экспорт

	Если НЕ ТолькоПросмотр Тогда
		ТекущийЭлемент = Элементы.ФормаОк;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура("ЗакрытьФорму", ЗакрытьФорму);
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрытьНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	СохранитьДанные(Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиентеЗавершение(Отказ, ДополнительныеПараметры) Экспорт 

	Если Не Отказ И Открыта() Тогда
		
		Модифицированность = Ложь;
		Если ДополнительныеПараметры.ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьРежимИзмененияСтатусаНалогоплательщика(ДатаИзменения, Отказ, ОповещениеЗавершения)
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	Оповещение = Новый ОписаниеОповещения("ЗапроситьРежимИзмененияСтатусаНалогоплательщикаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстКнопкиДа = НСтр("ru = 'Изменился статус налогоплательщика'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru =  'При редактировании изменился статус налогоплательщика. 
						|Если просто исправлены прежние данные (они были ошибочны), нажмите ""Исправлена ошибка"".
						|Если у сотрудника изменился статус с %1, нажмите ""Изменился статус налогоплательщика""'"), 
			Формат(ДатаИзменения, "ДФ='д ММММ гггг ""г""'"));
			
	РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ЭтаФорма, "СтатусФизическихЛицКакНалогоплательщиковНДФЛ", ТекстВопроса, ТекстКнопкиДа, Отказ, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьРежимИзмененияСтатусаНалогоплательщикаЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	СохранитьДанныеЗавершение(Отказ, ДополнительныеПараметры.ОповещениеЗавершения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеСтатусПериод(Форма, ДатаСеанса)

	// Не обязательно заполнение поля Период если данные по умолчанию и при этом 
	// записи о статусе еще нет.
	
	СтатусРезидент = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.СтатусыНалогоплательщиковПоНДФЛ.Резидент");
	
	Если Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Статус = СтатусРезидент
		И (Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛПрежняя.Период = НачалоМесяца(ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц())
		ИЛИ Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛПрежняя.Период = '00010101')
		ИЛИ НЕ Форма.ДоступноИзменениеНалоговИВзносов Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод",
			"АвтоОтметкаНезаполненного",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод",
			"ОтметкаНезаполненного",
			Ложь);
		
	Иначе
		
		Если Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период = НачалоМесяца(ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц())
			И Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Статус <> СтатусРезидент Тогда
			
			Если ЗначениеЗаполнено(Форма.ДатаПриема) Тогда
				Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период = НачалоМесяца(Форма.ДатаПриема);
			Иначе
				Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период = НачалоМесяца(ДатаСеанса);
			КонецЕсли;
			
		КонецЕсли; 
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод",
			"АвтоОтметкаНезаполненного",
			Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод",
			"ОтметкаНезаполненного",
			НЕ ЗначениеЗаполнено(Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период));
		
	КонецЕсли;
	
	Если Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период = НачалоМесяца(ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц()) Или Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений() Тогда
		Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод = '00010101';
	Иначе
		Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛПериод = Форма.СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИнфоНадписьВычеты(Форма)
	
	Если Форма.ВычетыПредоставлялись Тогда
		
		ТекстВычетыИнфо = НСтр("ru = 'Вычеты сотруднику сейчас не предоставляются, но ранее предоставлялись. Предыдущие заявления на вычеты можно посмотреть по ссылке ""Все заявления на вычеты""'");
		ЦветТекстаВычетыИнфо = Форма.ЦветСтиляРасширеннойПодсказки;;
		
	ИначеЕсли ЗначениеЗаполнено(Форма.ГоловнаяОрганизация) И НЕ Форма.ФизическоеЛицоСсылка.Пустая() Тогда
		
		ТекстВычетыИнфо = НСтр("ru = 'Вычеты сотруднику не предоставляются. Для того чтобы начать применение вычетов, введите заявление о предоставлении стандартных вычетов или уведомление нал.органа о праве на вычеты'");
		ЦветТекстаВычетыИнфо = Форма.ЦветСтиляРасширеннойПодсказки;
		
	Иначе
		
		Если Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьКадровыйУчет") Тогда
			ТекстВычетыИнфо = НСтр("ru = 'Для ввода заявления о предоставлении стандартных вычетов или уведомления нал.органа о праве на вычеты, необходимо оформить прием на работу'");
		Иначе
			Если ЗначениеЗаполнено(Форма.ГоловнаяОрганизация) Тогда
				ТекстВычетыИнфо = НСтр("ru = 'Для ввода заявления о предоставлении стандартных вычетов или уведомления нал.органа о праве на вычеты запишите сотрудника (Ctrl+S)'");
			Иначе
				ТекстВычетыИнфо = НСтр("ru = 'Для ввода заявления о предоставлении стандартных вычетов или уведомления нал.органа о праве на вычеты заполните организацию и запишите сотрудника (Ctrl+S)'");
			КонецЕсли;
		КонецЕсли;
		
		ЦветТекстаВычетыИнфо = Форма.ЦветСтиляПоясняющийОшибкуТекст;
		
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		"ГруппаНДФЛИнфо",
		ТекстВычетыИнфо);
		
	Форма.Элементы.ГруппаНДФЛИнфо.РасширеннаяПодсказка.ЦветТекста = ЦветТекстаВычетыИнфо;
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Форма.СтандартныеВычетыНДФЛВычетыНаДетей, "ДействуетДо", "ДействуетДоСтрокой");

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьВводаВычетов() Экспорт
	
	ДоступностьКоманд = ЗначениеЗаполнено(ГоловнаяОрганизация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НовоеЗаявлениеНаПредоставлениеВычетов1",
		"Доступность",
		ДоступностьКоманд);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НовоеУведомлениеОПравеНаИмущественныйВычет1",
		"Доступность",
		ДоступностьКоманд);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НовоеЗаявлениеНаПредоставлениеВычетов",
		"Доступность",
		ДоступностьКоманд);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НовоеУведомлениеОПравеНаИмущественныйВычет",
		"Доступность",
		ДоступностьКоманд);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВсеЗаявленияНаВычеты1",
		"Доступность",
		ДоступностьКоманд);
	
КонецПроцедуры

&НаСервере
Функция АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы)
	
	Возврат СотрудникиФормы.АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ПрочитатьНаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей()
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицоСсылка);
	НаборЗаписей.Отбор.ГоловнаяОрганизация.Установить(ГоловнаяОрганизация);
	
	НаборЗаписей.Прочитать();
	
	НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Загрузить(НаборЗаписей.Выгрузить());
	НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежейПрочитан = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей(НалоговыйПериод = Неопределено)
	
	Если НалоговыйПериод = Неопределено Тогда
		НалоговыйПериод = Год(ТекущаяДатаСеанса());
	КонецЕсли;
	
	СтрокиГода = НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.НайтиСтроки(Новый Структура("Год", НалоговыйПериод));
	Если СтрокиГода.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей, СтрокиГода[0]);
	Иначе
		
		РеквизитыУведомления = РегистрыСведений.РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.СоздатьМенеджерЗаписи();
		
		РеквизитыУведомления.Год = НалоговыйПериод;
		РеквизитыУведомления.ФизическоеЛицо = ФизическоеЛицоСсылка;
		РеквизитыУведомления.ГоловнаяОрганизация = ГоловнаяОрганизация;
		
		ЗначениеВРеквизитФормы(РеквизитыУведомления, "РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей");
		
	КонецЕсли;
	
	НалоговыйПериодПредыдущий = РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Год;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УведомлениеНаАвансовыеПлатежи",
		"ТолькоПросмотр",
		ТолькоПросмотр);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыУведомленияИФНСИзменялись(Форма)
	
	РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей = Форма.РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей;
	
	СтрокиГода = Форма.НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.НайтиСтроки(Новый Структура("Год", Форма.НалоговыйПериодПредыдущий));
	Если СтрокиГода.Количество() = 0 Тогда
		
		СтруктурыРазличны = ЗначениеЗаполнено(РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.НомерУведомления)
			Или ЗначениеЗаполнено(РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.ДатаУведомления)
			Или ЗначениеЗаполнено(РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.КодНалоговогоОргана);
		
	Иначе
		
		СтрокаГода = СтрокиГода[0];
		СтруктурыРазличны = СтрокаГода.НомерУведомления <> РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.НомерУведомления
			Или СтрокаГода.ДатаУведомления <> РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.ДатаУведомления
			Или СтрокаГода.КодНалоговогоОргана <> РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.КодНалоговогоОргана;
		
	КонецЕсли;
	
	Возврат СтруктурыРазличны;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииРеквизитыУведомленияИФНС()
	
	Если РеквизитыУведомленияИФНСИзменялись(ЭтаФорма) Тогда
		ПриИзмененииРеквизитыУведомленияИФНСНаСервере();
	Иначе
		ПрочитатьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей(РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Год);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитыУведомленияИФНСНаСервере()
	
	НалоговыйПериод = РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Год;
	СохранитьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей();
	ПрочитатьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей(НалоговыйПериод);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРеквизитыУведомленияПриЗакрытии()
	
	Если РеквизитыУведомленияИФНСИзменялись(ЭтаФорма) Тогда
		СохранитьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей()
	
	СтрокиГода = НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.НайтиСтроки(Новый Структура("Год", НалоговыйПериодПредыдущий));
	Если СтрокиГода.Количество() = 0 Тогда
		Запись = НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Добавить();
		Запись.ГоловнаяОрганизация = ГоловнаяОрганизация;
		Запись.ФизическоеЛицо = ФизическоеЛицоСсылка;
	Иначе
		Запись = СтрокиГода[0];
	КонецЕсли;
	
	Запись.Год = НалоговыйПериодПредыдущий;
	
	ЗаполнитьЗначенияСвойств(Запись, РеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей, "НомерУведомления,ДатаУведомления,КодНалоговогоОргана");
	НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Сортировать("Год,ДатаУведомления");
	
КонецПроцедуры

&НаСервере
Функция ЗаписиРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей()
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(НаборЗаписейРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей.Выгрузить());
	
КонецФункции

#КонецОбласти
