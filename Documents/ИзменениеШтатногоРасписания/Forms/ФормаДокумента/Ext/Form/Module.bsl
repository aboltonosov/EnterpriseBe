﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УправлениеШтатнымРасписаниемФормы.ДокументыПриСозданииНаСервере(ЭтаФорма, "Объект.ДатаВступленияВСилу");
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПриПолученииДанныхНаСервере();
		ОрганизацияПриИзмененииНаСервере();
		
	КонецЕсли; 
	
	Элементы.ПозицииТарифнаяСетка.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитТарифнаяСеткаТариф");
	Элементы.ПозицииРазрядКатегория.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитРазрядКатегорияТариф");	
	Элементы.ПозицииТарифнаяСеткаНадбавки.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитТарифнаяСеткаНадбавка");
	Элементы.ПозицииРазрядКатегорияНадбавки.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитРазрядКатегорияНадбавка");		
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыДанныеПозицииШтатногоРасписания" И Источник = ЭтаФорма Тогда
		
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СохранениеДанныхПозицииШРДокументаИзменениеШтатногоРасписания");
		
		ПрочитатьДанныеПозицииВФорму(Параметр);
		УправлениеШтатнымРасписаниемКлиент.ПозицииПриАктивизацииСтроки(ЭтаФорма, Истина);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеШтатнымРасписаниемФормы.ДокументыПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект, ТекущийОбъект.ДатаВступленияВСилу);
	
	ПриПолученииДанныхНаСервере();
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма);
	
	НастроитьОтображениеГруппыПодписантов();
	
	ЗарплатаКадрыРасширенный.ЗаблокироватьДокументДляРедактирования(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПроведениеДокументаИзменениеШтатногоРасписания");
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УправлениеШтатнымРасписаниемФормы.РеквизитВДанные(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеШтатнымРасписаниемКлиент.ОповеститьОЗаписиПозицийШтатногоРасписания(ЭтаФорма);
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеШтатнымРасписаниемФормы.ПоместитьДанныеОбъектаВДанныеФормы(ЭтаФорма, ТекущийОбъект, ТекущийОбъект.ДатаВступленияВСилу);	
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма);
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеШтатнымРасписаниемФормы.ДокументыОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаВступленияВСилуПриИзменении(Элемент)
	
	Если ПоследняяДатаУтверждения > Объект.ДатаВступленияВСилу
		Или ПоследняяДатаУтверждения > ПрежняяДатаУтверждения Тогда
		
		Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
			ЗаполнитьДокументНаСервере();
		КонецЕсли;
		
	КонецЕсли;
	
	ПрежняяДатаУтверждения = Объект.ДатаВступленияВСилу;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ЗаполнитьДокументНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыПозиции

&НаКлиенте
Процедура ПозицииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормыСДаннымиПоПозицииШРДокументаИзменениеШтатногоРасписания");	
	
	ОткрытьДанныеПозиции(Элемент.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПриАктивизацииСтроки(Элемент)
	
	УправлениеШтатнымРасписаниемКлиент.ПозицииПриАктивизацииСтроки(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ВводНовойПозицииШРДокументаИзменениеШтатногоРасписания");	
	
	Отказ = Истина;
	
	Если Копирование Тогда
		ПредыдущаяСтрока = Элемент.ТекущиеДанные
	КонецЕсли; 
	
	НоваяСтрокаПозиции = Объект.Позиции.Добавить();
	ИдентификаторТекущейПозиции = НоваяСтрокаПозиции.ПолучитьИдентификатор();
	Элемент.ТекущаяСтрока = ИдентификаторТекущейПозиции;
	
	Если Копирование Тогда
		ЗаполнитьЗначенияСвойств(НоваяСтрокаПозиции, ПредыдущаяСтрока);
		ТекущаяДолжность = Элемент.ТекущиеДанные.Должность;
	КонецЕсли;
	
	УправлениеШтатнымРасписаниемКлиент.ПозицииПриНачалеРедактирования(ЭтаФорма, ИдентификаторТекущейПозиции, Истина, Копирование);
	Если Копирование Тогда
		СкопироватьДанныеПозиции(ИдентификаторТекущейПозиции, ПредыдущаяСтрока.ПолучитьИдентификатор());
	КонецЕсли;
	
	ОткрытьДанныеПозиции(ИдентификаторТекущейПозиции);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПередУдалением(Элемент, Отказ)
	
	УправлениеШтатнымРасписаниемКлиент.ПозицииПередУдалением(ЭтаФорма, Отказ, Истина);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОбработкаВыбораПозицииШРДокументаИзменениеШтатногоРасписания");	
	
	Если ОбработатьВыбранныеПозиции(ВыбранноеЗначение) Тогда
		Если Объект.Позиции.Количество() > 0 Тогда
			Элементы.Позиции.ТекущаяСтрока = Объект.Позиции[Объект.Позиции.Количество() - 1].ПолучитьИдентификатор();
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаКлиенте
Процедура РуководительКадровойСлужбыПриИзменении(Элемент)
	
	НастроитьОтображениеГруппыПодписантов();
	
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
Процедура ИзменитьПозицию(Команда)
	
	ТекущееДействиеСПозицией = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка");
	ВыбратьПозициюИзСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПозицию(Команда)
	
	ТекущееДействиеСПозицией = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ЗакрытьПозицию");
	ВыбратьПозициюИзСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПозицииВСписке(Команда)
	
	УправлениеШтатнымРасписаниемКлиент.ЗакрытьПозицию(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УпорядочитьСписокПозиций(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СортировкаПозицийШРДокументаИзменениеШтатногоРасписания");
	
	УпорядочитьСписокПозицийНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаШтатногоРасписания(Команда)
	
	ПроверкаШтатногоРасписанияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьВКадровомУчете(Команда)
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьДокумент", Ложь);
	
	Если Модифицированность Или Не Объект.Проведен Тогда 
		ДополнительныеПараметры.ЗаписатьДокумент = Истина;
		ТекстВопроса = НСтр("ru = 'Для продолжения необходимо провести документ.'") + Символы.ПС + НСтр("ru = 'Продолжить?'"); 
		Оповещение = Новый ОписаниеОповещения("ОтразитьВКадровомУчетеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ОтразитьВКадровомУчетеЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтразитьВКадровомУчетеЗавершение(Ответ, ДополнительныеПараметры) Экспорт 

	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьДокумент Тогда
		
		Попытка
			РезультатЗаписи = Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		Исключение
			РезультатЗаписи = Ложь;
		КонецПопытки;
		
		Если Не РезультатЗаписи Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Во время сохранения произошли ошибки. Продолжение невозможно.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	КоличествоПозиций = Элементы.Позиции.ВыделенныеСтроки.Количество();
	
	Если КоличествоПозиций = 1 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ИзменениеШтатногоРасписания",		Объект.Ссылка);
		ЗначенияЗаполнения.Вставить("ИдентификаторСтрокиПозиции",		Элементы.Позиции.ТекущиеДанные.ИдентификаторСтрокиПозиции);
		ЗначенияЗаполнения.Вставить("Организация", 						Объект.Организация);
		ЗначенияЗаполнения.Вставить("Подразделение", 					Элементы.Позиции.ТекущиеДанные.Подразделение);
		ЗначенияЗаполнения.Вставить("Должность", 						Элементы.Позиции.ТекущиеДанные.Должность);
		ЗначенияЗаполнения.Вставить("ДолжностьПоШтатномуРасписанию", 	Элементы.Позиции.ТекущиеДанные.Позиция);
		ЗначенияЗаполнения.Вставить("ДатаИзменения", 					Объект.ДатаВступленияВСилу);
		
		ЗначенияЗаполнения.Вставить("ЭтоОтражениеИзмененияШтатногоРасписания", Истина);
		
		ПараметрыОткрытияФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.ИзменениеПлановыхНачислений.Форма.ФормаДокумента", ПараметрыОткрытияФормы);
	ИначеЕсли КоличествоПозиций > 1 Тогда  
		ПоказатьПредупреждение(, НСтр("ru = 'Отражение в кадровом учете необходимо вводить для каждой позиции отдельно.'"));
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана позиция для отражения в кадровом учете.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьПоТекущейКадровойРасстановке(Команда)
	
	ДополнитьПоТекущейКадровойРасстановкеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодборУправленческойПозиции()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ОрганизационнаяСтруктураКлиент");
		Модуль.ВыбратьУправленческуюПозициюИзСписка(ЭтотОбъект, АдресСпискаПодобранных());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.ДополнитьФормуДокументовИзмененияШтатногоРасписания(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыПлановыхНачислений();
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "";
	Возврат ОписаниеТаблицыВидовРасчета;
	
КонецФункции

&НаКлиенте
Функция ОписаниеТаблицыНачисленийНаКлиенте() Экспорт
	
	Возврат ОписаниеТаблицыНачислений();
	
КонецФункции

&НаСервере
Функция ОписаниеТаблицыНачисленийНаСервере() Экспорт
	
	Возврат ОписаниеТаблицыНачислений();
	
КонецФункции

&НаКлиенте
Функция ОписаниеКоманднойПанелиНачислений() Экспорт
	ОписаниеКоманднойПанелиНачислений = ЗарплатаКадрыРасширенныйКлиент.ОписаниеКоманднойПанелиНачислений();
	Возврат ОписаниеКоманднойПанелиНачислений
КонецФункции

&НаСервере
Процедура РассчитатьИтогиФОТПоПозиции(ИдентификаторТекущейСтроки)
	
	ДанныеТекущейПозиции = Объект.Позиции.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	ДанныеНачислений = Объект.Начисления.Выгрузить(Новый Структура("ИдентификаторСтрокиПозиции", ДанныеТекущейПозиции.ИдентификаторСтрокиПозиции));
	УправлениеШтатнымРасписанием.РассчитатьИтогиФОТПоПозиции(ЭтаФорма, ДанныеТекущейПозиции, ДанныеНачислений, ОписаниеТаблицыНачислений());
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УпорядочитьСписокПозицийНаСервере()
	
	УправлениеШтатнымРасписанием.УпорядочитьСписокПозиций(Объект.Позиции);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументНаСервере()
	
	УправлениеШтатнымРасписаниемФормы.ОчиститьДанныеТабличныхЧастейОбъектаФормы(ЭтаФорма);
	
	УправлениеШтатнымРасписаниемФормы.ЗаполнитьНовыйДокумент(ЭтаФорма, Объект.ДатаВступленияВСилу);
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма);
	
	УправлениеШтатнымРасписаниемФормы.ЗаполнитьПоследнююДатуУтвержденияШтатногоРасписания(ЭтаФорма, Объект.ДатаВступленияВСилу);
	
	ОписаниеКлючевыхРеквизитов = КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов();
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект, ОписаниеКлючевыхРеквизитов);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект, , ОписаниеКлючевыхРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаШтатногоРасписанияНаСервере()
	
	УправлениеШтатнымРасписаниемФормы.ПроверкаШтатногоРасписания(ЭтаФорма, Объект.ДатаВступленияВСилу);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.ДатаВступленияВСилу) Тогда
		
		ПоследняяДатаИзменений = УправлениеШтатнымРасписаниемФормы.ПоследняяДатаИзменений(Объект.Организация);
		Если Объект.ДатаВступленияВСилу <= ПоследняяДатаИзменений Тогда
			Объект.ДатаВступленияВСилу = КонецДня(ПоследняяДатаИзменений) + 1;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаВступленияВСилу) Тогда
		Объект.ДатаВступленияВСилу = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ЗаполнитьДокументНаСервере();
	КонецЕсли;
	
	УправлениеШтатнымРасписаниемФормы.ЗаполнитьПоследнююДатуУтвержденияШтатногоРасписания(ЭтаФорма, Объект.ДатаВступленияВСилу);
	УправлениеШтатнымРасписаниемФормы.УстановитьФункциональныеОпцииФормы(ЭтаФорма);
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма);
	
	ЗаполнитьДанныеФормыПоОрганизации();
	
КонецПроцедуры

&НаСервере
Функция ОбработатьВыбранныеПозиции(ВыбранноеЗначение)
	
	ПозицияДобавлена = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		ВыбранныеПозиции = ВыбранноеЗначение;
	Иначе
		ВыбранныеПозиции = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	КонецЕсли;
	
	Для каждого Позиция Из ВыбранныеПозиции Цикл
		
		СтруктураПоиска = Новый Структура("Позиция", Позиция);
		Если Объект.Позиции.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			
			УправлениеШтатнымРасписаниемФормы.ДобавитьДанныеПоПозиции(ЭтаФорма, Позиция, Объект.ДатаВступленияВСилу);
			
			ДобавленнаяСтрока = Объект.Позиции[Объект.Позиции.Количество() - 1];
			Если ЗначениеЗаполнено(ТекущееДействиеСПозицией) Тогда
				ДобавленнаяСтрока.Действие = ТекущееДействиеСПозицией;
			КонецЕсли;
			
			РассчитатьИтогиФОТПоПозиции(ДобавленнаяСтрока.ПолучитьИдентификатор());
			ПозицияДобавлена = Истина;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат ПозицияДобавлена;
	
КонецФункции

&НаСервере
Процедура УдалитьНачисленияИЕжегодныеОтпуска() Экспорт
	
	УправлениеШтатнымРасписаниемФормы.УдалитьНачисленияИЕжегодныеОтпуска(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции механизма выполнения длительных операций.

&НаКлиенте
Процедура ДополнитьПоТекущейКадровойРасстановкеНаКлиенте()
	
	ОчиститьСообщения();
	
	РезультатРаботыЗадания = ДополнитьПоТекущейКадровойРасстановкеНаСервере();
	
	Если РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
	Иначе
		
		ИдентификаторЗадания = РезультатРаботыЗадания.ИдентификаторЗадания;
		АдресХранилища		 = РезультатРаботыЗадания.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДополнитьПоТекущейКадровойРасстановкеНаСервере()
	
	ПараметрыВыполнения = Новый Структура("Организация,Подразделение,ДатаВступленияВСилу");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Объект);
	
	ПараметрыВыполнения.Вставить("Позиции", Объект.Позиции.Выгрузить());
	ПараметрыВыполнения.Вставить("Начисления", Объект.Начисления.Выгрузить());
	ПараметрыВыполнения.Вставить("Показатели", Объект.Показатели.Выгрузить());
	ПараметрыВыполнения.Вставить("ЕжегодныеОтпуска", Объект.ЕжегодныеОтпуска.Выгрузить());
	ПараметрыВыполнения.Вставить("Специальности", Объект.Специальности.Выгрузить());
	
	НаименованиеЗадания = НСтр("ru = 'Формирование позиций штатного расписания""'");
	
	РезультатРаботыЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"УправлениеШтатнымРасписаниемФормы.ДополнитьПоТекущейКадровойРасстановке",
		ПараметрыВыполнения,
		НаименованиеЗадания);
	
	АдресХранилища = РезультатРаботыЗадания.АдресХранилища;
	
	Если РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
		ЗаполнениеПослеВыполненияДлительнойОперации();
	КонецЕсли;
	
	Возврат РезультатРаботыЗадания;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				Состояние(НСтр("ru='Процесс формирования кадровых приказов завершен'"));
				ЗаполнениеПослеВыполненияДлительнойОперации();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
				
		КонецЕсли;
		
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
	ОповеститьОбИзменении(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеПослеВыполненияДлительнойОперации()
	
	УправлениеШтатнымРасписаниемФормы.ОбработатьЗаполнениеДокументаВФорме(ЭтаФорма);
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьДанныеПозиции(ИдентификаторТекущейПозиции, ИдентификаторПозицииИсточника)
	
	УправлениеШтатнымРасписаниемФормы.СкопироватьДанныеПозиции(ЭтаФорма, ИдентификаторТекущейПозиции, ИдентификаторПозицииИсточника);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанныеПозиции(ИдентификаторСтрокиТекущейПозиции)
	
	ДанныеПозиции = ОписаниеДанныхПозицииВХранилище(ИдентификаторСтрокиТекущейПозиции);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", ДанныеПозиции.Ключ);
	ПараметрыОткрытия.Вставить("АдресДанныхПозицииВХранилище", ДанныеПозиции.АдресДанныхПозицииВХранилище);
	
	ОткрытьФорму("Справочник.ШтатноеРасписание.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ОписаниеДанныхПозицииВХранилище(ИдентификаторСтрокиТекущейПозиции)
	
	Возврат УправлениеШтатнымРасписаниемФормы.ОписаниеДанныхПозицииВХранилище(ЭтаФорма, ИдентификаторСтрокиТекущейПозиции, Объект.ДатаВступленияВСилу, Объект.Подразделение);
	
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеПозицииВФорму(АдресДанныхПозиции)
	
	УправлениеШтатнымРасписаниемФормы.ПрочитатьДанныеПозицииВФорму(ЭтаФорма, АдресДанныхПозиции);
	РассчитатьИтогиФОТПоПозиции(ИдентификаторРедактируемойСтроки);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПозициюИзСписка(МножественныйВыбор = Истина)
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("Владелец", Объект.Организация);
	СтруктураОтбор.Вставить("Подразделение", Объект.Подразделение);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбор);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", МножественныйВыбор);
	ПараметрыОткрытия.Вставить("СкрытьПанельВводаДокументов", Истина);
	ПараметрыОткрытия.Вставить("АдресСпискаПодобранных", АдресСпискаПодобранных());
	
	ОткрытьФорму("Справочник.ШтатноеРасписание.ФормаВыбора", ПараметрыОткрытия, Элементы.Позиции);
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранных()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Позиции.Выгрузить(, "Позиция").ВыгрузитьКолонку("Позиция"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	УправлениеШтатнымРасписанием.ЗаполнитьПодписантовДокумента(Объект, Объект.ДатаВступленияВСилу, Ложь);
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписантов()
	
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.РуководительКадровойСлужбы");	
	
КонецПроцедуры	


#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Позиции");
	Массив.Добавить("Объект.Начисления");
	Массив.Добавить("Объект.Показатели");
	Массив.Добавить("Объект.ЕжегодныеОтпуска");
	Массив.Добавить("Объект.Специальности");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",		Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение",		Нстр("ru = 'подразделения'")));
	
	
	Если ЗначениеЗаполнено(ПоследняяДатаУтверждения) Тогда
		
		Массив.Добавить(Новый Структура("ЭлементФормы, Представление, ПредупреждениеПриРедактировании",
			"ДатаВступленияВСилу",
			Нстр("ru = 'даты изменения'"),
			НСтр("ru = 'Редактирование даты изменения приведет к перезаполнению табличных частей документа'")));
		
	КонецЕсли;
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти


#КонецОбласти
