﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Адрес = Параметры.Адрес;
	МодельБюджетирования = Параметры.МодельБюджетирования;
	Период = Параметры.Период;
	Периодичность = Параметры.Периодичность;
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
	НастройкиКонтрольныхОтчетов.Загрузить(ПолучитьИзВременногоХранилища(Адрес));
	Для каждого Строка Из НастройкиКонтрольныхОтчетов Цикл
		ПараметрыДоступностиОтборов = Отчеты.БюджетныйОтчет.ПараметрыДоступностиОтборов(Строка.ВидБюджета);
		ЗаполнитьЗначенияСвойств(Строка, ПараметрыДоступностиОтборов);
	КонецЦикла;
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НастройкиКонтрольныхОтчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СформироватьОтчет(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьОтчет(Элементы.НастройкиКонтрольныхОтчетов.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиКонтрольныхОтчетовПредставлениеОранизации.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ПредставлениеОранизации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Без отбора>'"));
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиКонтрольныхОтчетовПредставлениеПодразделения.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ПредставлениеПодразделения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Без отбора>'"));
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиКонтрольныхОтчетовСценарий.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ДоступенВыборСценария");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Установлен в виде бюджета>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиКонтрольныхОтчетовПредставлениеОранизации.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ДоступенВыборОрганизации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Установлен в виде бюджета>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиКонтрольныхОтчетовПредставлениеПодразделения.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ДоступенВыборПодразделения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Установлен в виде бюджета>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(ИдентификаторСтроки)
	
	ТекущаяСтрока = НастройкиКонтрольныхОтчетов.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.ВидБюджета) Тогда
		ВызватьИсключение НСтр("ru = 'Не определен Вид бюджета для построения отчета.'")
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("МодельБюджетирования", МодельБюджетирования);
	ПараметрыОтчета.Вставить("ВидБюджета", ТекущаяСтрока.ВидБюджета);
	ПараметрыОтчета.Вставить("Сценарий", ТекущаяСтрока.Сценарий);
	ПараметрыОтчета.Вставить("Подразделение", ТекущаяСтрока.Подразделения);
	ПараметрыОтчета.Вставить("Организация", ТекущаяСтрока.Организации);
	
	ПараметрыОтчета.Вставить("ДанныеКУтверждению", ТекущаяСтрока.ДанныеКУтверждению);
	ПараметрыОтчета.Вставить("ДанныеВПодготовке", ТекущаяСтрока.ДанныеВПодготовке);
	
	ПериодОтчета = ?(ЗначениеЗаполнено(Период), Период, ТекущаяДата());
	НачалоПериода = БюджетированиеКлиентСервер.ДатаНачалаПериода(ПериодОтчета, Периодичность);
	КонецПериода = БюджетированиеКлиентСервер.ДатаКонцаПериода(ПериодОтчета, Периодичность);
	ПараметрыОтчета.Вставить("Период", Новый СтандартныйПериод(НачалоПериода, КонецПериода));
	
	ПараметрыОтчета.Вставить("СформироватьБюджетныйОтчетПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("НеИспользоватьСохраненныеНастройки", Истина);
	ПараметрыОтчета.Вставить("ПоказыватьПанельНастройки", Ложь);
	
	ОткрытьФорму("Отчет.БюджетныйОтчет.ФормаОбъекта", ПараметрыОтчета, , Истина); 
	
КонецПроцедуры

#КонецОбласти
