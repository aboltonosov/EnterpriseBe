﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ЗаполнитьПервоначальныеЗначения();
		ПрочитатьВремяРегистрации();
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	ЭтотОбъект.ПодробныйРасчетФОТ = Ложь;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	 	
	ПрочитатьВремяРегистрации();
	
	ФОТСотрудниковВРеквизитФормы();

	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПрочитатьВремяРегистрации();
	
	ФОТСотрудниковВРеквизитФормы();

	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
    ЗарплатаКадрыРасширенныйКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	ДокументОснованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПрекращенияПриИзменении(Элемент)
	ДатаПрекращенияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СотрудникиФОТ" Тогда
		ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(Элемент.ТекущиеДанные, Элемент.ТекущаяСтрока);		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не Копирование И НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ДатаПрекращения = Объект.ДатаПрекращения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	СотрудникиСотрудникПриИзмененииНаСервере(Элементы.Сотрудники.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДатаПрекращенияПриИзменении(Элемент)
	СотрудникиДатаПрекращенияПриИзмененииНаСервере(Элементы.Сотрудники.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	ПараметрыОткрытия = Неопределено;
	КадровыйУчетРасширенныйКлиент.ДобавитьПараметрыОтбораПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(
		ЭтаФорма, ПараметрыОткрытия);
		
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники,
		Объект.Организация, 
		,
		Объект.ДатаПрекращения, 
		Объект.ДатаПрекращения,
		Истина, 
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетФОТПодробно(Команда)
	РасчетФОТПодробноНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#Область СервернаяЧастьОбработчиковСобытийЭлементовФормы

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	ЗаполнитьПоДокументуОснованию();
	ПрочитатьВремяРегистрации();
	ЗаполнитьФОТИСовокупныеСтавкиСотрудников();
	УстановитьОтображениеНадписей();
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ДатаПрекращенияПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
		
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	ФильтрСотрудников = Документы.ИзменениеПлановыхНачислений.ПустойФильтрСотрудников();
	
	ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Объект.Ссылка, ВыбранноеЗначение, Объект.ДатаПрекращения);
	
	Для Каждого Сотрудник Из ВыбранноеЗначение Цикл
		
		СтрокаСотрудника = Объект.Сотрудники.Добавить();
		СтрокаСотрудника.Сотрудник = Сотрудник;
		СтрокаСотрудника.ДатаПрекращения = Объект.ДатаПрекращения;
		СтрокаСотрудника.ВремяРегистрации = ВремяРегистрацииСотрудников.Получить(Сотрудник);
		
		ЭлементФильтра = ФильтрСотрудников.Добавить();
		ЭлементФильтра.Сотрудник = СтрокаСотрудника.Сотрудник;
		ЭлементФильтра.ДатаИзменения = СтрокаСотрудника.ВремяРегистрации;
		
	КонецЦикла;	
	
	ЗаполнитьФОТИСовокупныеСтавкиСотрудников(ФильтрСотрудников);
	
	УстановитьОтображениеНадписей();
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере(ИдентификаторСтроки)
	
	СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ЗаполнитьФОТИСовокупнуюСтавкуВСтроке(СтрокаСотрудника);
	
	УстановитьОтображениеНадписей();
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиДатаПрекращенияПриИзмененииНаСервере(ИдентификаторСтроки)
	
	СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПрочитатьВремяРегистрацииСтроки(Объект.Ссылка, СтрокаСотрудника);
	
	ЗаполнитьФОТИСовокупнуюСтавкуВСтроке(СтрокаСотрудника);
	
	УстановитьОтображениеНадписей();
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ПриПолученииДанныхНаСервере

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ПрочитатьВремяРегистрации();	

	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);	
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
	УстановитьВидимостьЭлементовФормы();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	УстановитьВидимостьКолонокПодробногоРасчета();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКолонокПодробногоРасчета()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтотОбъект.Элементы, "СотрудникиСовокупнаяТарифнаяСтавка", "Видимость", ЭтотОбъект.ПодробныйРасчетФОТ);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтотОбъект.Элементы, "СотрудникиФОТ", "Видимость", ЭтотОбъект.ПодробныйРасчетФОТ);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	УстановитьПривилегированныйРежим(Истина);
	СотрудникиДаты = Объект.Сотрудники.Выгрузить(, "ВремяРегистрации, Сотрудник");
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОКонкурирующихДокументахПлановыхНачислений(ЭтотОбъект, СотрудникиДаты, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ФОТ

&НаСервере
Процедура ФОТСотрудниковВРеквизитФормы(ФОТСотрудников = Неопределено)
	
	Если ФОТСотрудников = Неопределено Тогда
		
		ФОТСотрудников = ФОТСотрудников();	
		
	КонецЕсли;
	
	Отбор = Новый Структура("Сотрудник");
	
	Для каждого СтрокаСотрудника Из Объект.Сотрудники Цикл
		
		Отбор.Сотрудник = СтрокаСотрудника.Сотрудник;
		ФОТСотрудника = ФОТСотрудников.Получить(СтрокаСотрудника.Сотрудник);
		Если ФОТСотрудника <> Неопределено Тогда
			СтрокаСотрудника.ФОТ = ФОТСотрудника;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ФОТПлановыхНачисленийСотрудниковСИзменениямиДокумента(ПлановыеНачисленияПоказателиСотрудников)
	
	РассчитываемыеОбъекты = Новый Соответствие;	
	Сотрудники = Новый Соответствие;
	
	ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Объект.Организация);	
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	
	Отбор = Новый Структура("Сотрудник");
	
	ВремяРегистрацииСотрудников = ВремяРегистрацииСотрудников();
	Для Каждого СтрокаСотрудника Из ПлановыеНачисленияПоказателиСотрудников.Сотрудники Цикл
		Отбор.Сотрудник = СтрокаСотрудника.Сотрудник;		
		СтрокиПоСотруднику = ПлановыеНачисленияПоказателиСотрудников.НачисленияСотрудников.НайтиСтроки(Отбор);
		Для Каждого СтрокаНачисления Из СтрокиПоСотруднику Цикл	
			
			Если СтрокаНачисления.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеНачисления = ТаблицаНачислений.Добавить();
			ДанныеНачисления.Сотрудник = СтрокаСотрудника.Сотрудник;
			ДанныеНачисления.ГоловнаяОрганизация = ГоловнаяОрганизация;
			ДанныеНачисления.Период = ВремяРегистрацииСотрудников[СтрокаСотрудника.Сотрудник];

			ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
			ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
			ДанныеНачисления.Размер = СтрокаНачисления.Размер;
			
		КонецЦикла;
		
		СтрокиПоСотруднику = ПлановыеНачисленияПоказателиСотрудников.ПоказателиСотрудников.НайтиСтроки(Отбор);
		Для Каждого СтрокаПоказателя Из СтрокиПоСотруднику Цикл	
			
			ДанныеПоказателя = ТаблицаПоказателей.Добавить();
			ДанныеПоказателя.Сотрудник = СтрокаСотрудника.Сотрудник;
			ДанныеПоказателя.ГоловнаяОрганизация = ГоловнаяОрганизация;
			ДанныеПоказателя.Период = ВремяРегистрацииСотрудников[СтрокаСотрудника.Сотрудник];
			ДанныеПоказателя.Показатель = СтрокаПоказателя.Показатель;
			ДанныеПоказателя.ДокументОснование = СтрокаПоказателя.ДокументОснование;
			ДанныеПоказателя.Значение = СтрокаПоказателя.Значение;
			
		КонецЦикла;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатРасчета = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей);
	
	УстановитьПривилегированныйРежим(Ложь);			
	
	Возврат РезультатРасчета;
	
КонецФункции

&НаСервере
Функция ФОТСотрудников()
	
	ФОТСотрудников = Новый Соответствие;
	
	Если ЭтотОбъект.ПодробныйРасчетФОТ Тогда
		
		ФильтрСотрудников = Документы.ИзменениеПлановыхНачислений.ПустойФильтрСотрудников();
		
		Для каждого СтрокаСотрудника Из Объект.Сотрудники Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаПрекращения) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементФильтра = ФильтрСотрудников.Добавить();
			ЭлементФильтра.Сотрудник = СтрокаСотрудника.Сотрудник;
			ЭлементФильтра.ДатаИзменения = СтрокаСотрудника.ВремяРегистрации;
			
		КонецЦикла;	
		
		ПлановыеНачисленияПоказателиСотрудников = ПлановыеНачисленияПоказателиСотрудниковСИзменениямиДокумента(ФильтрСотрудников);
		
		ФОТПлановыхНачисленийСотрудников = ФОТПлановыхНачисленийСотрудниковСИзменениямиДокумента(ПлановыеНачисленияПоказателиСотрудников).ПлановыйФОТ;
		
		ФОТПлановыхНачисленийСотрудников.Свернуть("Сотрудник", "ВкладВФОТ");
		
		Для Каждого СтрокаТаблицы Из ФОТПлановыхНачисленийСотрудников Цикл
			ФОТСотрудников.Вставить(СтрокаТаблицы.Сотрудник, СтрокаТаблицы.ВкладВФОТ);
		КонецЦикла;	
		
	КонецЕсли;
	
	Возврат ФОТСотрудников;	
	
КонецФункции

&НаСервере
Процедура ЗаполнитьФОТСотрудниковВФорме()	
	
	ФОТСотрудников = ФОТСотрудников();	
	
	Для каждого СтрокаСотрудника Из Объект.Сотрудники Цикл
		
		СтрокаСотрудника.ФОТ = ФОТСотрудников.Получить(СтрокаСотрудника.Сотрудник);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РасчетФОТПодробноНаСервере()
	
	Пометка = ОбщегоНазначенияКлиентСервер.ЗначениеСвойстваЭлементаФормы(ЭтотОбъект.Элементы, "СотрудникиРасчетФОТПодробно", "Пометка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтотОбъект.Элементы, "СотрудникиРасчетФОТПодробно", "Пометка", Не Пометка);
	ЭтотОбъект.ПодробныйРасчетФОТ = Не Пометка;
	
	УстановитьВидимостьКолонокПодробногоРасчета();
	
	Если ЭтотОбъект.ПодробныйРасчетФОТ Тогда
		ЗаполнитьФОТСотрудниковВФорме();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СовокупнаяТарифнаяСтавка

&НаСервере
Процедура ЗаполнитьЗначенияСовокупныхТарифныхСтавокСотрудников(ЗначенияСовокупныхТарифныхСтавок)
	
	// Удаление текущих данных
	
	Для Каждого ДанныеСотрудника Из ЗначенияСовокупныхТарифныхСтавок Цикл 
		Отбор = Новый Структура("Сотрудник", ДанныеСотрудника.Сотрудник);
		НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда  
			НайденныеСтроки[0].СовокупнаяТарифнаяСтавка = ДанныеСотрудника.СовокупнаяТарифнаяСтавка;
			НайденныеСтроки[0].ВидТарифнойСтавки = ДанныеСотрудника.ВидТарифнойСтавки;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры
	
#КонецОбласти

#Область ПлановыеНачисленияПоказателиСотрудниковСИзменениямиДокумента

&НаСервере
Функция ПлановыеНачисленияПоказателиСотрудниковСИзменениямиДокумента(ФильтрСотрудников = Неопределено)
	
	НачисленияПоказателиСотрудников = ПлановыеНачисленияПоказателиСотрудников(ФильтрСотрудников);

	ПрименитьИзмененияВДокументеКПлановымНачислениямСотрудников(НачисленияПоказателиСотрудников, ФильтрСотрудников);
	
	Возврат НачисленияПоказателиСотрудников;
	
КонецФункции	   	

&НаСервере
Функция ПлановыеНачисленияПоказателиСотрудников(ФильтрСотрудников = Неопределено)
			
	ПараметрыПолучения = ПараметрыПолученияНачисленийПоказателейСотрудников();
	Если Не ФильтрСотрудников = Неопределено Тогда
		ПараметрыПолучения.Вставить("ИспользоватьФильтрСотрудников", Истина);
		ПараметрыПолучения.Вставить("ФильтрСотрудников", ФильтрСотрудников);
	КонецЕсли;
                    	
	НачисленияПоказателиСотрудников = Документы.ИзменениеПлановыхНачислений.НачисленияПоказателиСотрудников(ПараметрыПолучения);
	
	Возврат НачисленияПоказателиСотрудников;
	
КонецФункции	   	

&НаСервере
Функция НачисленияПоказателиСотрудникаПриведенныеДляФормыРедактирования(ПлановыеНачисленияПоказателиСотрудника, ФОТПлановыхНачисленийСотрудника)
	ФОТПлановыхНачисленийСотрудника.Индексы.Добавить("Начисление, ДокументОснование");
	
	МассивНачислений = Новый Массив;
	МассивПоказателей = Новый Массив;
	
	ИдентификаторСтрокиВидаРасчета = 1;
	
	ПостоянныеПоказателиНачислений = Новый Соответствие;
	
	// Добавление всех начислений сотрудника.
	Для Каждого СтрокаНачислений Из ПлановыеНачисленияПоказателиСотрудника.НачисленияСотрудников Цикл
		
		СтруктураНачисления = Новый Структура("Начисление,ДокументОснование,ИдентификаторСтрокиВидаРасчета,Размер,Действие");
		ЗаполнитьЗначенияСвойств(СтруктураНачисления, СтрокаНачислений);
		СтруктураНачисления.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
		
		Отбор = Новый Структура("Начисление, ДокументОснование", СтрокаНачислений.Начисление, СтрокаНачислений.ДокументОснование);
		НайденныеНачисления = ФОТПлановыхНачисленийСотрудника.НайтиСтроки(Отбор);
		Если НайденныеНачисления.Количество() > 0 Тогда
			СтруктураНачисления.Размер = НайденныеНачисления[0].ВкладВФОТ; 
		КонецЕсли;
		МассивНачислений.Добавить(СтруктураНачисления);
		
		// Добавление показателей начислений.
		
		ПостоянныеПоказателиНачисления = ПостоянныеПоказателиНачислений.Получить(СтрокаНачислений.Начисление); 
		Если ПостоянныеПоказателиНачисления = Неопределено Тогда
			ПостоянныеПоказателиНачисления = ПостоянныеПоказателиНачисления(СтрокаНачислений.Начисление);
			ПостоянныеПоказателиНачислений.Вставить(СтрокаНачислений.Начисление, ПостоянныеПоказателиНачисления);	
		КонецЕсли;
		
		Для каждого ПостоянныйПоказатель Из ПостоянныеПоказателиНачисления Цикл
			
			СтрокиПоказателей = ПлановыеНачисленияПоказателиСотрудника.ПоказателиСотрудников.НайтиСтроки(Новый Структура("Показатель,ДокументОснование", ПостоянныйПоказатель, СтрокаНачислений.ДокументОснование));
			Если СтрокиПоказателей.Количество() = 0 Тогда
				ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
				Продолжить;
			КонецЕсли;
			
			СтруктураПоказателя = Новый Структура("Показатель,ДокументОснование,ИдентификаторСтрокиВидаРасчета,Значение");
			СтруктураПоказателя.Показатель = СтрокиПоказателей[0].Показатель; 			
			СтруктураПоказателя.ДокументОснование = СтрокиПоказателей[0].ДокументОснование;
			СтруктураПоказателя.Значение = СтрокиПоказателей[0].Значение;
			СтруктураПоказателя.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
			
			МассивПоказателей.Добавить(СтруктураПоказателя);
			
		КонецЦикла;	  
		
		ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
		
	КонецЦикла;
	
	Возврат Новый Структура("Начисления,Показатели", МассивНачислений, МассивПоказателей);
	
КонецФункции

&НаСервере
Функция ПараметрыПолученияНачисленийПоказателейСотрудников()
	
	ПараметрыПолучения = Документы.ИзменениеПлановыхНачислений.ПараметрыПолученияНачисленийПоказателейСотрудников();
	ПараметрыПолучения.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыПолучения.Вставить("Организация", Объект.Организация);
	ПараметрыПолучения.Вставить("ДатаИзменения", Объект.ДатаПрекращения);
	ПараметрыПолучения.Вставить("ДатаОкончания", Объект.ДатаПрекращения);
		
	Возврат ПараметрыПолучения;	
	
КонецФункции

&НаСервере
Процедура ПрименитьИзмененияВДокументеКПлановымНачислениямСотрудников(НачисленияПоказателиСотрудников, ФильтрСотрудников = Неопределено)
	
	НачисленияПоказателиСотрудников.НачисленияСотрудников.Индексы.Добавить("Сотрудник, Начисление, ДокументОснование");
		
	Отбор = Новый Структура("Сотрудник, Начисление, ДокументОснование");
	Для каждого Строка Из Объект.Сотрудники Цикл
		Если ФильтрСотрудников <> Неопределено 
			И ФильтрСотрудников.Найти(Строка.Сотрудник) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Отбор.Сотрудник = Строка.Сотрудник;
		Отбор.ДокументОснование = Объект.ДокументОснование;
		Отбор.Начисление = Объект.Начисление;
		СтрокиНачисления = НачисленияПоказателиСотрудников.НачисленияСотрудников.НайтиСтроки(Отбор);
		Если СтрокиНачисления.Количество() > 0 Тогда
			СтрокиНачисления[0].Размер = 0; 
			СтрокиНачисления[0].Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить; 
		КонецЕсли;
	КонецЦикла;	
		
КонецПроцедуры

#КонецОбласти

#Область ФормаРедактированияСоставаНачисленийИУдержаний

&НаКлиенте
Процедура ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ТекущиеДанные, ТекущаяСтрока)
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Сотрудник) Тогда
		
		ПараметрыРедактирования = ПараметрыРедактированияСоставаНачисленийИУдержаний(ТекущаяСтрока);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("АдресВХранилище", ПоместитьВоВременноеХранилище(ПараметрыРедактирования, УникальныйИдентификатор));
		ПараметрыОткрытия.Вставить("ТолькоПросмотр", Истина);
		
		ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ПараметрыОткрытия, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыРедактированияСоставаНачисленийИУдержаний(ТекущаяСтрока)
	
	СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(ТекущаяСтрока);
	Сотрудник = СтрокаСотрудника.Сотрудник;
	
	ПараметрыРедактирования = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыРедактированияСоставаНачисленийИУдержаний();
	
	ПараметрыРедактирования.ВладелецНачисленийИУдержаний = Сотрудник;
	ПараметрыРедактирования.ДатаРедактирования = СтрокаСотрудника.ВремяРегистрации;
	ПараметрыРедактирования.Организация = Объект.Организация;
	ПараметрыРедактирования.РежимРаботы = 3;
	
	ФильтрСотрудников = Документы.ИзменениеПлановыхНачислений.ПустойФильтрСотрудников();
	ЭлементФильтра = ФильтрСотрудников.Добавить();
	ЭлементФильтра.Сотрудник = СтрокаСотрудника.Сотрудник;
	ЭлементФильтра.ДатаИзменения = СтрокаСотрудника.ВремяРегистрации;

	ПлановыеНачисленияПоказателиСотрудников = ПлановыеНачисленияПоказателиСотрудниковСИзменениямиДокумента(ФильтрСотрудников);
	ФОТПлановыхНачисленийСотрудникаСИзменениямиДокумента = ФОТПлановыхНачисленийСотрудниковСИзменениямиДокумента(ПлановыеНачисленияПоказателиСотрудников).ПлановыйФОТ;
	ПриведенныеНачисленияПоказатели = НачисленияПоказателиСотрудникаПриведенныеДляФормыРедактирования(ПлановыеНачисленияПоказателиСотрудников, ФОТПлановыхНачисленийСотрудникаСИзменениямиДокумента);
	
	ПараметрыРедактирования.ОписаниеТаблицыНачислений.Используется = Истина;
	ПараметрыРедактирования.ОписаниеТаблицыНачислений.ИзменятьСоставВидовРасчета = Ложь;
	ПараметрыРедактирования.ОписаниеТаблицыНачислений.ИзменятьЗначенияПоказателей = Ложь;
	ПараметрыРедактирования.ОписаниеТаблицыНачислений.НомерТаблицы = 1;
	ПараметрыРедактирования.ОписаниеТаблицыНачислений.ПоказатьФОТ = Истина;
	
	РедактируемыеНачисления = Новый Массив;
	ПараметрыРедактирования.ОписаниеТаблицыНачислений.РедактируемыеНачисления = РедактируемыеНачисления;
	
	ПараметрыРедактирования.ОписаниеТаблицыНачислений.Таблица = ПриведенныеНачисленияПоказатели.Начисления;
	ПараметрыРедактирования.Показатели = ПриведенныеНачисленияПоказатели.Показатели;
	
	Возврат ПараметрыРедактирования;
	
КонецФункции

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Сотрудники");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "ДокументОснование",	Нстр("ru = 'основания'")));
	Возврат Массив
КонецФункции

#КонецОбласти

&НаСервере
Процедура ЗаполнитьФОТИСовокупнуюСтавкуВСтроке(Строка)
	ФильтрСотрудников = Документы.ИзменениеПлановыхНачислений.ПустойФильтрСотрудников();
	ЭлементФильтра = ФильтрСотрудников.Добавить();
	ЭлементФильтра.Сотрудник = Строка.Сотрудник;
	ЭлементФильтра.ДатаИзменения = Строка.ВремяРегистрации;
	
	ЗаполнитьФОТИСовокупныеСтавкиСотрудников(ФильтрСотрудников);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФОТИСовокупныеСтавкиСотрудников(ФильтрСотрудников = Неопределено)
	
	Если ФильтрСотрудников = Неопределено Тогда
		
		ФильтрСотрудников = Документы.ИзменениеПлановыхНачислений.ПустойФильтрСотрудников();
		
		Для каждого СтрокаСотрудника Из Объект.Сотрудники Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаПрекращения) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементФильтра = ФильтрСотрудников.Добавить();
			ЭлементФильтра.Сотрудник = СтрокаСотрудника.Сотрудник;
			ЭлементФильтра.ДатаИзменения = СтрокаСотрудника.ВремяРегистрации;
			
		КонецЦикла;	
		
	КонецЕсли;
	
	ПлановыеНачисленияПоказателиСотрудников = ПлановыеНачисленияПоказателиСотрудниковСИзменениямиДокумента(ФильтрСотрудников);
	
	РассчитанныеДанные = ФОТПлановыхНачисленийСотрудниковСИзменениямиДокумента(ПлановыеНачисленияПоказателиСотрудников);
	
	РассчитанныеДанные.ПлановыйФОТ.Свернуть("Сотрудник", "ВкладВФОТ");
	
	ФОТСотрудников = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из РассчитанныеДанные.ПлановыйФОТ Цикл
		ФОТСотрудников.Вставить(СтрокаТаблицы.Сотрудник, СтрокаТаблицы.ВкладВФОТ);
	КонецЦикла;	
		
	ФОТСотрудниковВРеквизитФормы(ФОТСотрудников);
	
	ЗаполнитьЗначенияСовокупныхТарифныхСтавокСотрудников(РассчитанныеДанные.ТарифныеСтавки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументуОснованию()	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьПоДокументуОснованию();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПервоначальныеЗначения()
	ЗначенияДляЗаполнения = Новый Структура;
	ЗначенияДляЗаполнения.Вставить("Ответственный", "Объект.Ответственный");
	
	Если Параметры.ЗначенияЗаполнения.Свойство("Организация") 
		И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Организация) Тогда
		Объект.Организация = Параметры.ЗначенияЗаполнения.Организация;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаПрекращения) Тогда
		ЗначенияДляЗаполнения.Вставить("ДатаСобытия", "Объект.ДатаПрекращения");
	КонецЕсли;
	
	ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	СотрудникиДаты = Объект.Сотрудники.Выгрузить(, "Сотрудник, ДатаПрекращения");
	СотрудникиДаты.Колонки.ДатаПрекращения.Имя = "ДатаСобытия";
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Объект.Ссылка, СотрудникиДаты);
	
	Для Каждого Строка Из Объект.Сотрудники Цикл
		ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(Строка.ДатаПрекращения);
		Если ВремяРегистрацииСотрудников <> Неопределено Тогда 
			Строка.ВремяРегистрации = ВремяРегистрацииСотрудников.Получить(Строка.Сотрудник);
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяРегистрацииСтроки(Ссылка, Строка)
	
	Строка.ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Ссылка, Строка.Сотрудник, Строка.ДатаПрекращения);
	
КонецПроцедуры

&НаСервере
Функция ВремяРегистрацииСотрудников()
	
	ВремяРегистрацииСотрудников = Новый Соответствие;
	
	Для Каждого Строка Из Объект.Сотрудники Цикл
		ВремяРегистрацииСотрудников.Вставить(Строка.Сотрудник, Строка.ВремяРегистрации);
	КонецЦикла;	
	
	Возврат ВремяРегистрацииСотрудников;
	
КонецФункции

&НаСервере
Функция ПостоянныеПоказателиНачисления(Начисление) 
	
	ПостоянныеПоказатели = Новый Массив;
	
	ИнфоОВидеРасчета = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(Начисление);
	Для Каждого СтрокаПоказателя Из ИнфоОВидеРасчета.Показатели Цикл
		Если ЭтоПостоянныйПоказатель(СтрокаПоказателя) Тогда
			ПостоянныеПоказатели.Добавить(СтрокаПоказателя.Показатель);
		КонецЕсли;
	КонецЦикла;	
	
	Возврат ПостоянныеПоказатели;
	
КонецФункции

&НаСервере
Функция ЭтоПостоянныйПоказатель(СтрокаПоказателя) 
	
	ЭтоПостоянныйПоказатель = Истина;
	
	Если СтрокаПоказателя.ЗапрашиватьПриВводе Тогда
		ПоказательИнфо = ЗарплатаКадрыРасширенныйПовтИсп.СведенияОПоказателеРасчетаЗарплаты(СтрокаПоказателя.Показатель);
		Если ПоказательИнфо.СпособПримененияЗначений <> Перечисления.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное
			Или ПоказательИнфо.ЗначениеРассчитываетсяАвтоматически Тогда
			ЭтоПостоянныйПоказатель = Ложь;	
		КонецЕсли;
	Иначе
		ЭтоПостоянныйПоказатель = Ложь;	
	КонецЕсли;

	Возврат ЭтоПостоянныйПоказатель;
	
КонецФункции

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

